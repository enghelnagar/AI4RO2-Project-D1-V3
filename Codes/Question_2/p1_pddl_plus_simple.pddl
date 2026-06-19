;; ============================================================================
;; PROBLEM: Problem 1 - PDDL+ Simple Continuous Navigation
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; A baseline validation scenario for PDDL+ continuous dynamics. It models a
;; single legged rover navigating toward a rough terrain crater to collect and
;; deliver a single sample, verifying baseline process execution.
;;
;; Objectives:
;; 1. Validate continuous linear progress computation (* #t (speed)).
;; 2. Verify baseline risk accumulation within safe numeric bounds.
;; ============================================================================

(define (problem p1_pddl_plus_simple)
  (:domain planetary_rover_pddl_plus)
  (:objects
    legged - rover
    base rough_zone - location
    sample_a - sample
    flat rough - terrain
  )
  (:init
    (at legged base)
    (empty legged)
    (can-traverse legged flat)
    (can-traverse legged rough)

    (= (nav-progress legged) 0.0)
    (= (speed legged) 2.0)
    (= (risk-level legged) 0.0)

    (is-base base)
    
    ;; Keep terrain-type for resting checks
    (terrain-type base flat)
    (terrain-type rough_zone rough)
    (is-rough rough)

    (= (max-risk) 100.0)
    (= (risk-rate rough) 5.0)
    (= (risk-rate flat) 0.0)

    (connected base rough_zone)
    (connected rough_zone base)
    
    ;; MODIFIED: Explicitly define the terrain of the paths
    (path-terrain base rough_zone rough)
    (path-terrain rough_zone base rough)

    (= (distance base rough_zone) 10.0)
    (= (distance rough_zone base) 10.0)

    (sample-at sample_a rough_zone)
  )
  (:goal (delivered sample_a))
)