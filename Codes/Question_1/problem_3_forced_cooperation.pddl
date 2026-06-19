;; ============================================================================
;; PROBLEM: Problem 3 - Basic PDDL Forced Cooperation via Terrain Constraints
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; PROGRAM: Master of Science in Robotics Engineering, University of Genoa
;; ============================================================================
;; Description: 
;; A strict multi-agent coordination scenario. The environment forces cooperation 
;; by restricting the wheeled rover to flat terrain and the legged rover to 
;; rough terrain, necessitating a sample handover at a shared mixed-terrain zone.
;;
;; Objectives:
;; 1. Demonstrate emergent multi-robot cooperation without explicit communication.
;; 2. Validate the use of drop and pick-up actions as intermediate states 
;;    to seamlessly transfer payloads between heterogeneous agents.
;; ============================================================================

(define (problem p3_forced_cooperation)
  (:domain planetary_rover_heterogeneous)
  
  (:objects
    wheeled_rover legged_rover - rover
    base transfer_zone rocky_crater - location
    sample_alpha - sample
    flat rough mixed - terrain
  )

  (:init
    ;; Wheeled Rover: Fast, but strictly limited to flat and mixed terrains
    (at wheeled_rover base)
    (empty wheeled_rover)
    (can-traverse wheeled_rover flat)
    (can-traverse wheeled_rover mixed)

    ;; Legged Rover: Slower, limited to rough and mixed terrains
    (at legged_rover transfer_zone)
    (empty legged_rover)
    (can-traverse legged_rover rough)
    (can-traverse legged_rover mixed)

    ;; Location designations and their terrain assignments
    (is-base base)
    (terrain-type base flat)
    (terrain-type transfer_zone mixed)
    (terrain-type rocky_crater rough)

    ;; Bidirectional connectivity ensuring a linear path
    (connected base transfer_zone)
    (connected transfer_zone base)
    (connected transfer_zone rocky_crater)
    (connected rocky_crater transfer_zone)

    ;; Sample located in an area inaccessible to the wheeled rover
    (sample-at sample_alpha rocky_crater)
  )

  (:goal
    (delivered sample_alpha)
  )
)