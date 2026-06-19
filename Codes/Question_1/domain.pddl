;; ============================================================================
;; DOMAIN: Planetary Rover - Heterogeneous Multi-Robot Exploration (Q1)
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; This domain models a heterogeneous multi-robot planetary exploration scenario.
;; It explicitly defines robot capabilities regarding terrain traversal to avoid
;; action duplication. Cooperation emerges logically from spatial and terrain
;; constraints rather than explicit multi-agent coordination actions.
;; ============================================================================

(define (domain planetary_rover_heterogeneous)
  (:requirements :strips :typing)
  
  (:types 
    rover location sample terrain
  )

  (:predicates
    ;; Topological and spatial predicates
    (at ?r - rover ?l - location)
    (connected ?l1 ?l2 - location)
    
    ;; Terrain and capability predicates
    (terrain-type ?l - location ?t - terrain)
    (can-traverse ?r - rover ?t - terrain)
    
    ;; Sample and manipulation predicates
    (sample-at ?s - sample ?l - location)
    (carrying ?r - rover ?s - sample)
    (empty ?r - rover)
    
    ;; Goal-related predicates
    (delivered ?s - sample)
    (is-base ?l - location)
  )

  ;; ============================================================================
  ;; ACTION: navigate
  ;; Description: Moves a rover between two connected locations if the rover 
  ;; possesses the capability to traverse the target location's terrain.
  ;; ============================================================================
  (:action navigate
    :parameters (?r - rover ?from - location ?to - location ?t - terrain)
    :precondition (and 
                    (at ?r ?from)
                    (connected ?from ?to)
                    (terrain-type ?to ?t)
                    (can-traverse ?r ?t)
                  )
    :effect (and 
              (not (at ?r ?from))
              (at ?r ?to)
            )
  )

  ;; ============================================================================
  ;; ACTION: collect-sample
  ;; Description: Allows a rover with an empty gripper to pick up a sample 
  ;; from its current location.
  ;; ============================================================================
  (:action collect-sample
    :parameters (?r - rover ?s - sample ?l - location)
    :precondition (and 
                    (at ?r ?l)
                    (sample-at ?s ?l)
                    (empty ?r)
                  )
    :effect (and 
              (not (sample-at ?s ?l))
              (not (empty ?r))
              (carrying ?r ?s)
            )
  )

  ;; ============================================================================
  ;; ACTION: drop-sample
  ;; Description: Allows a rover to drop a sample at its current location. 
  ;; This action is crucial for multi-agent coordination, acting as an 
  ;; intermediate state for sample handovers.
  ;; ============================================================================
  (:action drop-sample
    :parameters (?r - rover ?s - sample ?l - location)
    :precondition (and 
                    (at ?r ?l)
                    (carrying ?r ?s)
                  )
    :effect (and 
              (not (carrying ?r ?s))
              (empty ?r)
              (sample-at ?s ?l)
            )
  )

  ;; ============================================================================
  ;; ACTION: deliver-sample
  ;; Description: Deposits the sample at the designated base station to 
  ;; achieve the mission goal.
  ;; ============================================================================
  (:action deliver-sample
    :parameters (?r - rover ?s - sample ?l - location)
    :precondition (and 
                    (at ?r ?l)
                    (is-base ?l)
                    (carrying ?r ?s)
                  )
    :effect (and 
              (not (carrying ?r ?s))
              (empty ?r)
              (delivered ?s)
            )
  )
)