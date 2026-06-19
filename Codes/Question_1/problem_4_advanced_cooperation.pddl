;; ============================================================================
;; PROBLEM: Problem 4 - Basic PDDL Advanced Coordination & Complex Topology
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; A comprehensive multi-agent benchmark featuring complex network topology 
;; and multiple targets. Two heterogeneous rovers must coordinate to retrieve 
;; samples from various rough-terrain craters and optimize delivery to the base.
;;
;; Objectives:
;; 1. Challenge the planner with combinatorial complexity in task allocation 
;;    and multi-agent pathfinding.
;; 2. Optimize parallel execution and handover sequences across multiple 
;;    locations and agents.
;; ============================================================================

(define (problem p4_advanced_cooperation)
  (:domain planetary_rover_heterogeneous)
  
  (:objects
    wheeled_rover legged_rover - rover
    base hub crater_north crater_south - location
    sample_n sample_s - sample
    flat rough mixed - terrain
  )

  (:init
    ;; Rovers and their capabilities
    (at wheeled_rover base)
    (empty wheeled_rover)
    (can-traverse wheeled_rover flat)
    (can-traverse wheeled_rover mixed)

    (at legged_rover hub)
    (empty legged_rover)
    (can-traverse legged_rover rough)
    (can-traverse legged_rover mixed)

    ;; Environment definitions
    (is-base base)
    (terrain-type base flat)
    (terrain-type hub mixed)
    (terrain-type crater_north rough)
    (terrain-type crater_south rough)

    ;; Complex routing map
    (connected base hub)
    (connected hub base)
    (connected hub crater_north)
    (connected crater_north hub)
    (connected hub crater_south)
    (connected crater_south hub)
    ;; Legged rover can travel directly between craters
    (connected crater_north crater_south)
    (connected crater_south crater_north)

    ;; Samples distributed in deep rough terrain
    (sample-at sample_n crater_north)
    (sample-at sample_s crater_south)
  )

  (:goal
    (and 
      (delivered sample_n)
      (delivered sample_s)
    )
  )
)