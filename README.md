# CIVentral Backend REST API Gateway

Centralized backend API and MySQL database service connecting the **CIVentral Citizen Mobile App** and the **CIVentral Web Admin Dashboard**.

---

## Architecture Overview

```
[ 📱 Citizen Mobile App ] ──┐
                            ├──▶ [ ⚙️ CIVentral Backend API Gateway ] ──▶ [ 🗄️ MySQL Database ]
[ 💻 City Hall Admin ]    ──┘
```

Both the Mobile App and the Admin Panel communicate solely via standard HTTPS REST endpoints.

---

## API Endpoints

### 1. Citizen Mobile Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/citizen/check-account.php` | Checks if account exists by email/mobile |
| `POST` | `/api/citizen/login.php` | Citizen authentication |
| `POST` | `/api/citizen/register.php` | New citizen registration |
| `POST` | `/api/citizen/verify-citizen.php` | Submits citizen ID & residency verification |
| `GET` | `/api/citizen/profile.php` | Gets citizen profile & current verification status |

#### Verification Submission Payload (`POST /api/citizen/verify-citizen.php`):
```json
{
  "citizen_user_id": 1001,
  "first_name": "Danny",
  "middle_name": "Toledano",
  "last_name": "Espelita",
  "suffix": "Jr.",
  "sex": "Male",
  "place_of_birth": "Caloocan City",
  "birth_date": "1998-05-15",
  "civil_status": "Single",
  "employment_status": "Employed (Private Sector)",
  "occupation": "Corporate / Office Employee",
  "educational_attainment": "College / Bachelor’s Degree Graduate",
  "district": "District 1",
  "barangay": "Barangay 171 (Bagumbong)",
  "street_address": "Block 12 Lot 5, Sampaguita St.",
  "years_resident": 12,
  "valid_id_type": "Philippine Identification System (PhilSys) National ID",
  "valid_id_number": "1234-5678-9012-3456",
  "id_front_photo_url": "base64_or_image_url",
  "selfie_photo_url": "base64_or_image_url"
}
```

---

### 2. Admin Side Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/admin/verifications.php` | Lists verification submissions (`?status=Pending`, `Approved`, or `all`) |
| `POST` | `/api/admin/review-citizen.php` | Approves or Rejects a verification submission |
| `GET` | `/api/admin/dashboard-stats.php` | Real-time counts (total citizens, pending, approved) |

#### Admin Review Payload (`POST /api/admin/review-citizen.php`):
```json
{
  "verification_id": 1,
  "action": "approve", // "approve" or "reject"
  "reviewed_by": "Officer Santos",
  "rejection_reason": "" // Optional if rejected
}
```

---

## Deployment & Setup

### A. Deploy to Dokploy
1. Create a new GitHub repository: `civentral-backend`.
2. Push this folder to your repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: CIVentral Backend REST API Gateway"
   git branch -M main
   git remote add origin https://github.com/<your-username>/civentral-backend.git
   git push -u origin main
   ```
3. In your Dokploy dashboard, add a new Application from GitHub pointing to your `civentral-backend` repository.
4. Set Environment Variables:
   * `DB_HOST`: `<your-mysql-container-name>` (or `127.0.0.1`)
   * `DB_NAME`: `citizen_verification` (or `civentral`)
   * `DB_USER`: `<your-db-user>`
   * `DB_PASSWORD`: `<your-db-password>`

---

### B. Run Locally in XAMPP
1. Copy this `civentral-backend` folder into `C:\xampp\htdocs\civentral-backend`.
2. Start Apache and MySQL in your XAMPP Control Panel.
3. Access: `http://localhost/civentral-backend/index.php`.
