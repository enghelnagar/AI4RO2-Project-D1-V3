;; ============================================================================
;; DOMAIN: Planetary Rover - PDDL+ Extension (Q2)
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description:
;; This PDDL+ domain introduces continuous dynamics, time, and numeric fluents.
;; It models continuous movement and dynamic risk accumulation when traversing
;; rough terrains. It forces the planner to reason about time and risk 
;; thresholds, requiring proactive resting and strict multi-robot coordination 
;; to avoid system failure via events.
;; ============================================================================

(define (domain planetary_rover_pddl_plus)
  (:requirements :strips :typing :numeric-fluents :time :negative-preconditions)
  
  (:types 
    rover location sample terrain
  )
  (:predicates
    (at ?r - rover ?l - location)
    (connected ?l1 ?l2 - location)
    (terrain-type ?l - location ?t - terrain)
    (path-terrain ?l1 ?l2 - location ?t - terrain)
    (can-traverse ?r - rover ?t - terrain)
    (is-rough ?t - terrain)
    (sample-at ?s - sample ?l - location)
    (carrying ?r - rover ?s - sample)
    (empty ?r - rover)
    (delivered ?s - sample)
    (is-base ?l - location)
    
    (is-navigating ?r - rover)
    (target-loc ?r - rover ?l - location)
    (traversing-terrain ?r - rover ?t - terrain)
    (is-resting ?r - rover)
    (is-broken ?r - rover)
  )
  (:functions
    (distance ?l1 ?l2 - location)
    (nav-progress ?r - rover)
    (speed ?r - rover)
    (risk-level ?r - rover)
    (max-risk)
    (risk-rate ?t - terrain)
  )
  ;; ============================================================================
  ;; ACTIONS: Navigation
  ;; ============================================================================
  (:action start-navigate
    :parameters (?r - rover ?from - location ?to - location ?t - terrain)
    :precondition (and 
                    (at ?r ?from)
                    (connected ?from ?to)
                    (path-terrain ?from ?to ?t)
                    (can-traverse ?r ?t)
                    (not (is-navigating ?r))
                    (not (is-resting ?r))
                    (not (is-broken ?r))
                  )
    :effect (and 
              (not (at ?r ?from))
              (is-navigating ?r)
              (target-loc ?r ?to)
              (traversing-terrain ?r ?t)
              (assign (nav-progress ?r) (distance ?from ?to))
            )
  )
  (:action end-navigate
    :parameters (?r - rover ?to - location ?t - terrain)
    :precondition (and 
                    (is-navigating ?r)
                    (target-loc ?r ?to)
                    (traversing-terrain ?r ?t)
                    (<= (nav-progress ?r) 0.0)
                    (not (is-broken ?r))
                  )
    :effect (and 
              (not (is-navigating ?r))
              (not (target-loc ?r ?to))
              (not (traversing-terrain ?r ?t))
              (at ?r ?to)
              (assign (nav-progress ?r) 0.0)
            )
  )
  ;; ============================================================================
  ;; ACTIONS: Risk Management
  ;; ============================================================================
  (:action start-rest
    :parameters (?r - rover ?l - location ?t - terrain)
    :precondition (and 
                    (at ?r ?l)
                    (terrain-type ?l ?t)
                    (not (is-rough ?t))
                    (not (is-navigating ?r))
                    (not (is-resting ?r))
                    (> (risk-level ?r) 0.0)
                    (not (is-broken ?r))
                  )
    :effect (is-resting ?r)
  )
  (:action stop-rest
    :parameters (?r - rover)
    :precondition (and 
                    (is-resting ?r)
                    (not (is-broken ?r))
                  )
    :effect (not (is-resting ?r))
  )
  ;; ============================================================================
  ;; ACTIONS: Manipulation
  ;; ============================================================================
  (:action collect-sample
    :parameters (?r - rover ?s - sample ?l - location)
    :precondition (and 
                    (at ?r ?l)
                    (sample-at ?s ?l)
                    (empty ?r)
                    (not (is-navigating ?r))
                    (not (is-resting ?r))
                    (not (is-broken ?r))
                  )
    :effect (and 
              (not (sample-at ?s ?l))
              (not (empty ?r))
              (carrying ?r ?s)
            )
  )
  (:action drop-sample
    :parameters (?r - rover ?s - sample ?l - location)
    :precondition (and 
                    (at ?r ?l)
                    (carrying ?r ?s)
                    (not (is-navigating ?r))
                    (not (is-resting ?r))
                    (not (is-broken ?r))
                  )
    :effect (and 
              (not (carrying ?r ?s))
              (empty ?r)
              (sample-at ?s ?l)
            )
  )
  (:action deliver-sample
    :parameters (?r - rover ?s - sample ?l - location)
    :precondition (and 
                    (at ?r ?l)
                    (is-base ?l)
                    (carrying ?r ?s)
                    (not (is-navigating ?r))
                    (not (is-broken ?r))
                  )
    :effect (and 
              (not (carrying ?r ?s))
              (empty ?r)
              (delivered ?s)
            )
  )
  ;; ============================================================================
  ;; PROCESSES: Continuous Environmental Dynamics
  ;; ============================================================================
  
  (:process navigate-process
    :parameters (?r - rover)
    :precondition (and 
                    (is-navigating ?r)
                    (> (nav-progress ?r) 0.0)
                    (not (is-broken ?r))  ;; FIXED: Process stops when broken!
                  )
    :effect (decrease (nav-progress ?r) (* #t (speed ?r)))
  )
  (:process accumulate-risk
    :parameters (?r - rover ?t - terrain)
    :precondition (and 
                    (is-navigating ?r)
                    (> (nav-progress ?r) 0.0)
                    (traversing-terrain ?r ?t)
                    (is-rough ?t)
                    (not (is-broken ?r))  ;; FIXED: Process stops when broken!
                  )
    :effect (increase (risk-level ?r) (* #t (risk-rate ?t)))
  )
  (:process recover-risk
    :parameters (?r - rover)
    :precondition (and 
                    (is-resting ?r)
                    (> (risk-level ?r) 0.0)
                    (not (is-broken ?r))  ;; FIXED: Process stops when broken!
                  )
    :effect (decrease (risk-level ?r) (* #t 15.0))
  )
  ;; ============================================================================
  ;; EVENTS: Autonomous System Failure
  ;; ============================================================================
  
  (:event risk-failure
    :parameters (?r - rover)
    :precondition (and 
                    (> (risk-level ?r) (max-risk))
                    (not (is-broken ?r))
                  )
    :effect (and 
              (is-broken ?r)
              (assign (speed ?r) 0.0)
            )
  )
)