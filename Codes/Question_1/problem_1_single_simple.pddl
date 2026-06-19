;; ============================================================================
;; PROBLEM: Problem 1 - Basic PDDL Single Robot, Simple Environment
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; A baseline validation scenario for classical PDDL. It models a single 
;; wheeled rover navigating exclusively on flat terrain to collect and 
;; deliver a single sample.
;;
;; Objectives:
;; 1. Validate basic topological navigation and terrain-capability constraints.
;; 2. Verify the sequential execution of collect, move, and deliver actions 
;;    for a single independent agent.
;; ============================================================================

(define (problem p1_single_simple)
  (:domain planetary_rover_heterogeneous)
  
  (:objects
    wheeled_rover - rover\
    base loc_1 - location
    sample_a - sample
    flat - terrain
  )

  (:init
    ;; Rover initial state and capabilities
    (at wheeled_rover base)
    (empty wheeled_rover)
    (can-traverse wheeled_rover flat)

    ;; Environment topology and terrain types
    (is-base base)
    (terrain-type base flat)
    (terrain-type loc_1 flat)

    ;; Graph connectivity (bidirectional)
    (connected base loc_1)
    (connected loc_1 base)

    ;; Initial sample location
    (sample-at sample_a loc_1)
  )

  (:goal
    (delivered sample_a)
  )
)