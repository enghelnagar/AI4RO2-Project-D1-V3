;; ============================================================================
;; PROBLEM: Problem 3 - Time-Critical Heterogeneous Multi-Robot Cooperation
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; A multi-agent hybrid planning scenario requiring tight temporal synchronization.
;; Features a fast wheeled rover restricted to flat areas and a slower legged
;; rover handling high-risk rough zones.
;;
;; Objectives:
;; 1. Synthesize cross-terrain sample handover via intermediate drop/collect states.
;; 2. Optimize system efficiency by utilizing the wheeled rover's high speed
;;    for the final delivery to minimize cumulative mission time.
;; ============================================================================

(define (problem p3_pddl_plus_coop_timing)
  (:domain planetary_rover_pddl_plus)
  (:objects
    wheeled legged - rover
    base junction rocky_crater - location
    sample_c - sample
    flat rough highway - terrain  ;; NEW: highway terrain added
  )
  (:init
    (at wheeled base)
    (empty wheeled)
    (can-traverse wheeled flat)
    (can-traverse wheeled highway) ;; Wheeled CAN traverse highway
    (= (nav-progress wheeled) 0.0)
    (= (speed wheeled) 5.0)
    (= (risk-level wheeled) 0.0)
    (at legged junction)
    (empty legged)
    (can-traverse legged flat)
    (can-traverse legged rough)
    ;; Legged CANNOT traverse highway -> Forces cooperation!
    (= (nav-progress legged) 0.0)
    (= (speed legged) 1.5)
    (= (risk-level legged) 0.0)
    (is-base base)
    (terrain-type base flat)
    (terrain-type junction flat)
    (terrain-type rocky_crater rough)
    (is-rough rough)
    (= (max-risk) 100.0)
    (= (risk-rate rough) 8.0)
    (= (risk-rate flat) 0.0)
    (= (risk-rate highway) 0.0)
    (connected base junction)
    (connected junction base)
    (path-terrain base junction highway)
    (path-terrain junction base highway)
    (= (distance base junction) 20.0)
    (= (distance junction base) 20.0)
    (connected junction rocky_crater)
    (connected rocky_crater junction)
    (path-terrain junction rocky_crater rough)
    (path-terrain rocky_crater junction rough)
    ;; MODIFIED: Distance reduced to 8.0 so round trip risk is 85.33 (Safe)
    (= (distance junction rocky_crater) 8.0)
    (= (distance rocky_crater junction) 8.0)
    (sample-at sample_c rocky_crater)
  )
  (:goal (delivered sample_c))
)