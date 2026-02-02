---
name: data-model
description: Design database schemas and ER diagrams using Mermaid erDiagram syntax. Use when defining data structures, entity relationships, database security, and performance considerations.
---

You are a database architect. Design normalized, efficient, and secure data models with clear entity relationships.

## Instructions

When the user provides a data domain via `$ARGUMENTS`:

1. **Identify** entities and their attributes
2. **Define** relationships between entities
3. **Apply** normalization principles (at least 3NF)
4. **Consider** security and sensitive data handling
5. **Generate** Mermaid ER diagram

## Output Format

```markdown
## Data Model: [Domain Name]

### Overview
[Brief description of the data domain]

### ER Diagram

```mermaid
erDiagram
    ENTITY1 ||--o{ ENTITY2 : "relationship"
    ENTITY1 {
        int id PK
        string name
        datetime created_at
    }
    ENTITY2 {
        int id PK
        int entity1_id FK
        string description
    }
```

### Entity Definitions

#### Entity: [ENTITY1]
| Column | Type | Constraints | Nullable | Default | Description |
|--------|------|-------------|----------|---------|-------------|
| id | INT | PK, AUTO_INCREMENT | No | - | Primary key |
| name | VARCHAR(100) | NOT NULL | No | - | Display name |
| email | VARCHAR(255) | UNIQUE, NOT NULL | No | - | User email |
| status | ENUM | - | No | 'active' | active, inactive, pending |
| created_at | DATETIME | NOT NULL | No | CURRENT_TIMESTAMP | Creation timestamp |
| updated_at | DATETIME | ON UPDATE | Yes | NULL | Last update timestamp |
| version | INT | NOT NULL | No | 1 | Optimistic locking |

### Relationships

| From | To | Type | On Delete | On Update | Description |
|------|-----|------|-----------|-----------|-------------|
| User | Order | 1:N | RESTRICT | CASCADE | A user can have many orders |
| Order | OrderItem | 1:N | CASCADE | CASCADE | An order contains many items |
| Product | OrderItem | 1:N | RESTRICT | CASCADE | A product can be in many order items |

### Indexes

| Table | Index Name | Columns | Type | Purpose |
|-------|------------|---------|------|---------|
| users | idx_users_email | email | UNIQUE | Fast email lookup |
| orders | idx_orders_user_date | user_id, created_at | INDEX | User order history queries |
| orders | idx_orders_status | status | INDEX | Filter by status |

### Constraints

#### Foreign Key Constraints
- `order.user_id` → `user.id` (ON DELETE RESTRICT, ON UPDATE CASCADE)
- `order_item.order_id` → `order.id` (ON DELETE CASCADE, ON UPDATE CASCADE)

#### Check Constraints
- `CHECK (status IN ('active', 'inactive', 'pending'))`
- `CHECK (end_date >= start_date)`
- `CHECK (quantity > 0)`

#### Unique Constraints
- `UNIQUE (employee_id, leave_type_id, year)` for leave balance

### Security Considerations

#### Sensitive Data Classification
| Column | Classification | Handling |
|--------|----------------|----------|
| email | PII | Encrypted at rest |
| phone | PII | Encrypted at rest |
| password_hash | Secret | bcrypt, never logged |
| salary | Confidential | Row-level access control |
| id_number | PII | Encrypted, masked in logs |

#### Access Control
- Row-level security for multi-tenant data
- Column-level encryption for PII fields
- Audit logging for sensitive operations

### Audit Trail (if applicable)

| Column | Type | Description |
|--------|------|-------------|
| created_at | DATETIME | Record creation time |
| created_by | INT FK | User who created |
| updated_at | DATETIME | Last modification time |
| updated_by | INT FK | User who last updated |
| deleted_at | DATETIME | Soft delete timestamp |
| deleted_by | INT FK | User who deleted |

### Notes
- [Normalization decisions]
- [Performance considerations]
- [Future scalability]
```

---

## Relationship Notation (Mermaid)

| Symbol | Meaning | Example |
|--------|---------|---------|
| `\|\|--o{` | One to Many (required) | User has many Orders |
| `\|\|--\|\|` | One to One | User has one Profile |
| `}o--o{` | Many to Many | Students ↔ Courses |
| `\|o--o{` | Zero-or-One to Many | User may have Orders |
| `\|\|--o\|` | One to Zero-or-One | User may have Avatar |

---

## Data Type Guidelines

### Identifiers
| Type | When to Use | Example |
|------|-------------|---------|
| INT AUTO_INCREMENT | Simple, sequential IDs | Internal tables |
| BIGINT AUTO_INCREMENT | High-volume tables | Logs, events |
| UUID / BINARY(16) | Distributed systems, security | Public-facing IDs |
| ULID | Time-sortable + random | Event sourcing |

### Strings
| Type | Max Length | Use Case |
|------|------------|----------|
| CHAR(n) | Fixed | Country codes, status codes |
| VARCHAR(n) | Variable | Names, emails, descriptions |
| TEXT | 65,535 | Long text content |
| MEDIUMTEXT | 16MB | Articles, documents |
| JSON | - | Semi-structured data |

### Numbers
| Type | Range | Use Case |
|------|-------|----------|
| TINYINT | -128 to 127 | Boolean, small enums |
| INT | ±2.1B | Standard integers |
| BIGINT | ±9.2E18 | Large counters |
| DECIMAL(19,4) | - | Currency, precise decimals |
| FLOAT/DOUBLE | - | Scientific (avoid for money!) |

### Dates & Times
| Type | Storage | Use Case |
|------|---------|----------|
| DATE | 3 bytes | Birth dates, holidays |
| DATETIME | 8 bytes | Fixed moments, no timezone |
| TIMESTAMP | 4 bytes | Auto-converts UTC, events |
| TIME | 3 bytes | Duration, time-of-day |

### Boolean
- Use `TINYINT(1)` or `BOOLEAN` (MySQL alias)
- Consider `ENUM('Y','N')` for readability

---

## Normalization Guidelines

### 1NF (First Normal Form)
- [ ] Each column contains atomic (indivisible) values
- [ ] No repeating groups or arrays
- [ ] Each row is unique (has primary key)

### 2NF (Second Normal Form)
- [ ] Meets 1NF
- [ ] All non-key attributes depend on the entire primary key
- [ ] No partial dependencies (for composite keys)

### 3NF (Third Normal Form)
- [ ] Meets 2NF
- [ ] No transitive dependencies
- [ ] Non-key columns depend only on the primary key

### When to Denormalize
| Scenario | Approach |
|----------|----------|
| Heavy read, light write | Duplicate frequently joined data |
| Reporting/Analytics | Create summary tables |
| Caching | Store computed values with TTL |
| Performance critical | Trade storage for speed |

---

## Many-to-Many Relationship Example

For M:N relationships, use a junction (bridge) table:

```mermaid
erDiagram
    EMPLOYEE }o--o{ SKILL : has
    EMPLOYEE ||--o{ EMPLOYEE_SKILL : "through"
    SKILL ||--o{ EMPLOYEE_SKILL : "through"

    EMPLOYEE {
        int id PK
        string name
    }

    SKILL {
        int id PK
        string name
        string category
    }

    EMPLOYEE_SKILL {
        int employee_id PK,FK
        int skill_id PK,FK
        int proficiency_level
        date acquired_date
        int certified_by FK
    }
```

---

## Self-Referencing Relationship Example

For hierarchical data (e.g., manager-employee, categories):

```mermaid
erDiagram
    EMPLOYEE ||--o{ EMPLOYEE : manages

    EMPLOYEE {
        int id PK
        string name
        string email
        int manager_id FK "References EMPLOYEE.id"
        int department_id FK
        datetime created_at
    }
```

**Note**: The `manager_id` references the same table (`EMPLOYEE.id`).

---

## Complete Example

Input: `/data-model Employee leave management`

Output:

## Data Model: Employee Leave Management

### Overview
Database schema for managing employee leave requests, balances, and approvals, compliant with Taiwan Labor Standards Act requirements.

### ER Diagram

```mermaid
erDiagram
    EMPLOYEE ||--o{ LEAVE_REQUEST : submits
    EMPLOYEE ||--o{ LEAVE_BALANCE : has
    EMPLOYEE ||--o{ EMPLOYEE : "managed by"
    LEAVE_TYPE ||--o{ LEAVE_REQUEST : categorizes
    LEAVE_TYPE ||--o{ LEAVE_BALANCE : tracks

    EMPLOYEE {
        int id PK
        string employee_no UK "Unique employee number"
        string name "NOT NULL"
        string email UK "NOT NULL"
        int manager_id FK "Self-reference to EMPLOYEE"
        int department_id FK
        date hire_date "For leave calculation"
        datetime created_at
        datetime updated_at
    }

    LEAVE_TYPE {
        int id PK
        string code UK "e.g., ANNUAL, SICK"
        string name "NOT NULL"
        int default_days "Annual quota"
        boolean is_paid
        boolean requires_approval
        int max_consecutive_days
        datetime created_at
    }

    LEAVE_REQUEST {
        int id PK
        int employee_id FK "NOT NULL"
        int leave_type_id FK "NOT NULL"
        date start_date "NOT NULL"
        date end_date "NOT NULL"
        decimal hours "For partial days"
        string status "pending, approved, rejected, cancelled"
        string reason
        int approver_id FK "References EMPLOYEE"
        datetime approved_at
        string rejection_reason
        datetime created_at
        datetime updated_at
        int version "Optimistic locking"
    }

    LEAVE_BALANCE {
        int id PK
        int employee_id FK "NOT NULL"
        int leave_type_id FK "NOT NULL"
        int year "NOT NULL"
        decimal total_days "Annual quota"
        decimal used_days "Days taken"
        decimal pending_days "Pending approval"
        decimal remaining_days "Computed"
        datetime updated_at
    }
```

### Entity Definitions

#### Entity: EMPLOYEE
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| employee_no | VARCHAR(20) | UNIQUE, NOT NULL | Employee number |
| name | VARCHAR(100) | NOT NULL | Full name |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Work email (PII) |
| manager_id | INT | FK → EMPLOYEE.id, NULL | Direct manager |
| department_id | INT | FK → DEPARTMENT.id | Department |
| hire_date | DATE | NOT NULL | For seniority calculation |
| created_at | DATETIME | NOT NULL | Record creation |
| updated_at | DATETIME | NULL | Last update |

#### Entity: LEAVE_REQUEST
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INT | PK, AUTO_INCREMENT | Primary key |
| employee_id | INT | FK, NOT NULL | Requesting employee |
| leave_type_id | INT | FK, NOT NULL | Type of leave |
| start_date | DATE | NOT NULL | Leave start |
| end_date | DATE | NOT NULL | Leave end |
| hours | DECIMAL(5,2) | NULL | For partial day |
| status | ENUM | NOT NULL, DEFAULT 'pending' | Request status |
| reason | TEXT | NULL | Leave reason |
| approver_id | INT | FK → EMPLOYEE.id | Manager who approved/rejected |
| approved_at | DATETIME | NULL | Approval timestamp |
| rejection_reason | VARCHAR(500) | NULL | If rejected |
| created_at | DATETIME | NOT NULL | Submission time |
| updated_at | DATETIME | NULL | Last modification |
| version | INT | NOT NULL, DEFAULT 1 | Optimistic locking |

### Relationships

| From | To | Type | On Delete | Description |
|------|-----|------|-----------|-------------|
| EMPLOYEE | LEAVE_REQUEST | 1:N | RESTRICT | Employee submits requests |
| EMPLOYEE | EMPLOYEE | 1:N | SET NULL | Manager hierarchy |
| LEAVE_TYPE | LEAVE_REQUEST | 1:N | RESTRICT | Categorizes leave |
| EMPLOYEE | LEAVE_BALANCE | 1:N | CASCADE | Employee's balances |

### Indexes

| Table | Index Name | Columns | Purpose |
|-------|------------|---------|---------|
| leave_request | idx_lr_employee_status | employee_id, status | My pending requests |
| leave_request | idx_lr_approver_status | approver_id, status | Manager's pending approvals |
| leave_request | idx_lr_dates | start_date, end_date | Date range queries |
| leave_balance | idx_lb_emp_year | employee_id, year | Balance lookup |
| leave_balance | uk_lb_emp_type_year | employee_id, leave_type_id, year | Unique constraint |

### Constraints

#### Check Constraints
- `CHECK (end_date >= start_date)`
- `CHECK (hours IS NULL OR hours > 0)`
- `CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled'))`
- `CHECK (total_days >= 0 AND used_days >= 0)`

#### Business Rules
- Annual leave quota based on seniority (Taiwan LSA)
- Cannot exceed leave balance (checked at application layer)
- Manager cannot approve own leave requests

### Security Considerations

| Column | Classification | Handling |
|--------|----------------|----------|
| email | PII | Encrypted at rest |
| name | PII | Access controlled |
| salary (if added) | Confidential | Row-level security |

### Notes
- Leave balance `remaining_days` can be computed or stored (denormalized for performance)
- Soft delete via status change, not physical deletion
- Audit trail via created_at/updated_at + application-level logging
- Consider partitioning leave_request by year for large datasets
