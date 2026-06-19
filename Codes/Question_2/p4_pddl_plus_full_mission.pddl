;; ============================================================================
;; PROBLEM: Problem 4 - Scaled Multi-Agent Hybrid Planning and Optimization
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; The final comprehensive benchmark scenario testing full model scalability.
;; Multiple samples are distributed across an interconnected complex network 
;; of rough craters and flat transit hubs, requiring simultaneous coordination.
;;
;; Objectives:
;; 1. Challenge the ENHSP planner with concurrent continuous processes.
;; 2. Optimize multi-robot task allocation and trajectory scheduling under
;;    strict, competing risk and temporal constraints.
;; ============================================================================

(define (problem p4_pddl_plus_full_mission)
  (:domain planetary_rover_pddl_plus)
  (:objects
    wheeled legged - rover
    base transfer_point north_crater south_crater - location
    sample_n sample_s - sample
    flat rough highway - terrain ;; NEW: highway terrain added
  )
  (:init
    (at wheeled base)
    (empty wheeled)
    (can-traverse wheeled flat)
    (can-traverse wheeled highway)
    (= (nav-progress wheeled) 0.0)
    (= (speed wheeled) 6.0)
    (= (risk-level wheeled) 0.0)
    (at legged transfer_point)
    (empty legged)
    (can-traverse legged flat)
    (can-traverse legged rough)
    (= (nav-progress legged) 0.0)
    (= (speed legged) 2.0)
    (= (risk-level legged) 0.0)
    (is-base base)
    (terrain-type base flat)
    (terrain-type transfer_point flat)
    (terrain-type north_crater rough)
    (terrain-type south_crater rough)
    (is-rough rough)
    (= (max-risk) 100.0)
    (= (risk-rate rough) 6.0)
    (= (risk-rate flat) 0.0)
    (= (risk-rate highway) 0.0)
    (connected base transfer_point)
    (connected transfer_point base)
    (path-terrain base transfer_point highway)
    (path-terrain transfer_point base highway)
    (= (distance base transfer_point) 25.0)
    (= (distance transfer_point base) 25.0)
    (connected transfer_point north_crater)
    (connected north_crater transfer_point)
    (path-terrain transfer_point north_crater rough)
    (path-terrain north_crater transfer_point rough)
    (= (distance transfer_point north_crater) 12.0)
    (= (distance north_crater transfer_point) 12.0)
    (connected transfer_point south_crater)
    (connected south_crater transfer_point)
    (path-terrain transfer_point south_crater rough)
    (path-terrain south_crater transfer_point rough)
    (= (distance transfer_point south_crater) 15.0)
    (= (distance south_crater transfer_point) 15.0)
    (sample-at sample_n north_crater)
    (sample-at sample_s south_crater)
  )
  (:goal 
    (and 
      (delivered sample_n)
      (delivered sample_s)
    )
  )
  (:metric minimize (total-time))
)