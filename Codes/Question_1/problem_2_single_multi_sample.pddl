;; ============================================================================
;; PROBLEM: Problem 2 - Basic PDDL Single Robot, Multiple Samples
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; An extended single-agent scenario requiring the collection of multiple 
;; samples distributed across a flat terrain network.
;;
;; Objectives:
;; 1. Test the planner's ability to sequence multiple independent delivery goals.
;; 2. Ensure state variables (e.g., gripper capacity via 'empty' predicate) 
;;    reset correctly between consecutive manipulation cycles.
;; ============================================================================

(define (problem p2_single_multi_sample)
  (:domain planetary_rover_heterogeneous)
  
  (:objects
    wheeled_rover - rover
    base loc_1 loc_2 - location
    sample_a sample_b - sample
    flat - terrain
  )

  (:init
    (at wheeled_rover base)
    (empty wheeled_rover)
    (can-traverse wheeled_rover flat)

    (is-base base)
    (terrain-type base flat)
    (terrain-type loc_1 flat)
    (terrain-type loc_2 flat)

    (connected base loc_1)
    (connected loc_1 base)
    (connected loc_1 loc_2)
    (connected loc_2 loc_1)

    (sample-at sample_a loc_1)
    (sample-at sample_b loc_2)
  )

  (:goal
    (and 
      (delivered sample_a)
      (delivered sample_b)
    )
  )
)