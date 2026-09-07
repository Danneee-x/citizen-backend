# CIVentral - Citizen Verification Subsystem Backend

This repository is the dedicated backend service for the **Citizen Verification & Identity Subsystem**. It connects the **Citizen Mobile App** verification form, your **Web Admin Side Panel**, and provides an API for other group subsystems to verify citizen status.

---

## Subsystem Architecture

```
[ 📱 Mobile App (Verification Form) ] ──┐
                                       ├──▶ [ ⚙️ Verification Backend API ] ──▶ [ 🗄️ MySQL Database ]
[ 💻 Web Admin Side (Review & Approve) ]─┘           ▲
                                                     │
[ 🤝 Other Group Subsystems (e.g. Health, BPLO) ] ───┘ (Queries: Is Citizen Verified?)
```

---

## API Endpoints

### 1. Mobile App Endpoints
* **`POST /api/citizen/verify-citizen.php`**  
  Submits citizen verification details, residency, valid ID number, ID photo, and selfie photo. Saves to `citizen_verifications` with status `Pending`.
* **`GET /api/citizen/verification-status.php?citizen_user_id=1001`**  
  Checks whether a citizen is `Pending`, `Approved`, or `Rejected`.

### 2. Web Admin Side Endpoints
* **`GET /api/admin/verifications.php?status=Pending`**  
  Fetches all submissions for the Admin Panel to display in review tables.
* **`POST /api/admin/review-citizen.php`**  
  Allows the Admin to click **Approve** or **Reject** with payload:
  ```json
  {
    "verification_id": 1,
    "action": "approve",
    "reviewed_by": "Officer Name"
  }
  ```
* **`GET /api/admin/dashboard-stats.php`**  
  Returns total verifications, pending count, approved count, and rejected count for dashboard cards.

### 3. Inter-Subsystem Shared API (For Other Groups)
* **`GET /api/external/check-verification.php?citizen_user_id=1001`**  
  Allows other group subsystems (Health, Business Permits, Education, etc.) to securely check if a citizen is legitimately verified.

---

## Deployment (Dokploy)
1. Push this repository to your GitHub: `civentral-verification-backend`.
2. Connect to Dokploy as an Application.
3. Configure Environment Variables:
   * `DB_HOST`: `<mysql-container-name>`
   * `DB_NAME`: `citizen_verification`
   * `DB_USER`: `<mysql-user>`
   * `DB_PASSWORD`: `<mysql-password>`
