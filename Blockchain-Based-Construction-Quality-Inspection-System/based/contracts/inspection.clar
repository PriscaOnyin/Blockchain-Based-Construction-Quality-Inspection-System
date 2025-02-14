;; Define constants
(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-invalid-inspection (err u101))

;; Define data maps
(define-map inspections
  { inspection-id: uint }
  {
    inspector: principal,
    timestamp: uint,
    status: (string-ascii 20),
    details: (string-utf8 500)
  }
)

(define-map approvals
  { inspection-id: uint }
  {
    approver: principal,
    timestamp: uint,
    status: (string-ascii 20)
  }
)

;; Define public functions

;; Record a new inspection
(define-public (record-inspection (inspection-id uint) (status (string-ascii 20)) (details (string-utf8 500)))
  (let
    (
      (inspection {
        inspector: tx-sender,
        timestamp: stacks-block-height,
        status: status,
        details: details
      })
    )
    (if (map-insert inspections { inspection-id: inspection-id } inspection)
      (ok inspection-id)
      err-invalid-inspection
    )
  )
)

;; Approve an inspection
(define-public (approve-inspection (inspection-id uint) (status (string-ascii 20)))
  (let
    (
      (approval {
        approver: tx-sender,
        timestamp: stacks-block-height,
        status: status
      })
    )
    (if (map-insert approvals { inspection-id: inspection-id } approval)
      (ok inspection-id)
      err-invalid-inspection
    )
  )
)

;; Read-only functions

;; Get inspection details
(define-read-only (get-inspection (inspection-id uint))
  (map-get? inspections { inspection-id: inspection-id })
)

;; Get approval details
(define-read-only (get-approval (inspection-id uint))
  (map-get? approvals { inspection-id: inspection-id })
)

;; Check if an inspection exists
(define-read-only (inspection-exists (inspection-id uint))
  (is-some (map-get? inspections { inspection-id: inspection-id }))
)

;; Check if an approval exists
(define-read-only (approval-exists (inspection-id uint))
  (is-some (map-get? approvals { inspection-id: inspection-id }))
)

