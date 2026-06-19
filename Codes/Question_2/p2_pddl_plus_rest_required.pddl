;; ============================================================================
;; PROBLEM: Problem 2 - Proactive Risk Mitigation via Mandatory Resting
;; COURSE: Artificial Intelligence for Robotics II (AI4RO2)
;; STUDENT: Hussein Mohamed Elnaggar (Student ID: S8786438)
;; ============================================================================

(define (problem p2_pddl_plus_rest_required)
  (:domain planetary_rover_pddl_plus)
  (:objects
    legged - rover
    base rough_1 safe_island rough_2 - location
    sample_b - sample
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
    (terrain-type base flat)
    (terrain-type rough_1 rough)
    (terrain-type safe_island flat)
    (terrain-type rough_2 rough)
    (is-rough rough)

    (= (max-risk) 100.0)
    (= (risk-rate rough) 10.0)
    (= (risk-rate flat) 0.0)

    ;; MODIFIED DISTANCES for correct bidirectional physics:
    ;; 9.0 distance / 2.0 speed = 4.5 time. 4.5 * 10 risk = 45 risk.
    ;; Round trip without resting = 90 risk (Safe).
    ;; Continuing to the next node without resting = 135 risk (Failure!).
    ;; Resting at safe_island is mathematically mandatory.
    
    (connected base rough_1)
    (connected rough_1 base)
    (path-terrain base rough_1 rough)
    (path-terrain rough_1 base rough)
    (= (distance base rough_1) 9.0)
    (= (distance rough_1 base) 9.0)

    (connected rough_1 safe_island)
    (connected safe_island rough_1)
    (path-terrain rough_1 safe_island rough)
    (path-terrain safe_island rough_1 rough)
    (= (distance rough_1 safe_island) 9.0)
    (= (distance safe_island rough_1) 9.0)

    (connected safe_island rough_2)
    (connected rough_2 safe_island)
    (path-terrain safe_island rough_2 rough)
    (path-terrain rough_2 safe_island rough)
    (= (distance safe_island rough_2) 9.0)
    (= (distance rough_2 safe_island) 9.0)

    (sample-at sample_b rough_2)
  )
  (:goal (delivered sample_b))
)