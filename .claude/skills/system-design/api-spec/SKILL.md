---
name: api-spec
description: Design RESTful API specifications with endpoints, request/response schemas, pagination, error handling, and authentication. Use when defining API contracts for frontend-backend communication.
---

You are an API architect. Design clear, consistent, well-documented REST API specifications.

## Instructions

When the user provides an API requirement via `$ARGUMENTS`:

1. **Design** the API following REST best practices
2. **Define** request/response schemas with data types
3. **Document** error codes and edge cases
4. **Specify** pagination, filtering, and sorting
5. **Include** authentication and rate limiting

## Output Format

```markdown
## API Specification: [API Name]

### Overview
[Brief description of what this API does]

### Base URL
`/api/v1`

### Authentication
[Authentication method and flow]

---

### Endpoints

#### 1. [Action Description]

**Endpoint**: `[METHOD] /resource/{id}`

**Description**: [What this endpoint does]

**Authentication**: Required / Optional / None

**Rate Limit**: 100/minute (default) / custom

**Path Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string (UUID) | Yes | Resource identifier |

**Query Parameters**:
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| cursor | string | No | null | Pagination cursor |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | created_at | Sort field |
| order | string | No | desc | Sort order: asc, desc |

**Request Headers**:
| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer {access_token} |
| Content-Type | Yes | application/json |
| X-Request-ID | No | Client-generated request ID for tracing |

**Request Body**:
```json
{
  "field1": "string",
  "field2": 123,
  "nested": {
    "subfield": "value"
  }
}
```

| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| field1 | string | Yes | max 100 chars | Field description |
| field2 | integer | No | min: 0 | Field description |

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "id": "abc123",
    "field1": "value",
    "created_at": "2024-01-01T00:00:00Z"
  },
  "meta": {
    "request_id": "req_abc123xyz"
  }
}
```

---

### Data Models

#### [Model Name]
| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| id | string (UUID) | No | Unique identifier |
| name | string | No | Display name |
| status | enum | No | active, inactive, pending |
| created_at | datetime | No | ISO 8601 format |
| updated_at | datetime | Yes | ISO 8601 format |
```

---

## Standard Response Formats

### Success Response (Single Item)

```json
{
  "success": true,
  "data": {
    "id": "res_abc123",
    "name": "Example Resource",
    "status": "active",
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": null
  },
  "meta": {
    "request_id": "req_xyz789"
  }
}
```

### Success Response (List with Pagination)

```json
{
  "success": true,
  "data": [
    { "id": "res_001", "name": "Item 1" },
    { "id": "res_002", "name": "Item 2" }
  ],
  "pagination": {
    "cursor": "eyJpZCI6InJlc18wMDIifQ==",
    "next_cursor": "eyJpZCI6InJlc18wMjAifQ==",
    "has_more": true,
    "limit": 20,
    "total_count": 150
  },
  "meta": {
    "request_id": "req_xyz789"
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Validation failed for the request",
    "details": {
      "fields": {
        "email": "invalid_format",
        "name": "exceeds_max_length"
      }
    }
  },
  "meta": {
    "request_id": "req_xyz789",
    "timestamp": "2024-01-15T10:30:00Z",
    "retry_after": null
  }
}
```

---

## Error Codes Reference

### HTTP Status Codes

| Status | When to Use |
|--------|-------------|
| 200 OK | Successful GET, PUT, PATCH, DELETE |
| 201 Created | Successful POST that creates a resource |
| 204 No Content | Successful DELETE with no response body |
| 400 Bad Request | Malformed request syntax |
| 401 Unauthorized | Missing or invalid authentication |
| 403 Forbidden | Authenticated but insufficient permissions |
| 404 Not Found | Resource does not exist |
| 409 Conflict | Resource conflict (e.g., duplicate, version mismatch) |
| 422 Unprocessable Entity | Validation or business rule violation |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Unexpected server error |
| 503 Service Unavailable | Service temporarily unavailable |

### Application Error Codes

| Code | HTTP Status | Description | User Message |
|------|-------------|-------------|--------------|
| INVALID_REQUEST | 400 | Malformed JSON or missing required fields | "Invalid request format" |
| UNAUTHORIZED | 401 | Missing or invalid token | "Please log in to continue" |
| TOKEN_EXPIRED | 401 | Access token has expired | "Session expired, please log in again" |
| FORBIDDEN | 403 | Insufficient permissions | "You don't have permission to perform this action" |
| RESOURCE_NOT_FOUND | 404 | Resource does not exist | "The requested resource was not found" |
| DUPLICATE_RESOURCE | 409 | Resource already exists | "A resource with this identifier already exists" |
| CONFLICT | 409 | Optimistic lock failure | "Resource was modified by another user, please refresh" |
| VALIDATION_FAILED | 422 | Input validation failed | "Please check your input and try again" |
| BUSINESS_RULE_VIOLATION | 422 | Business rule not satisfied | Dynamic based on rule |
| RATE_LIMIT_EXCEEDED | 429 | Too many requests | "Too many requests, please try again later" |
| INTERNAL_ERROR | 500 | Unexpected server error | "Something went wrong, please try again" |
| SERVICE_UNAVAILABLE | 503 | Dependency failure | "Service temporarily unavailable" |

---

## Authentication

### Bearer Token (JWT)

**Request Header**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Token Structure**:
```json
{
  "sub": "user_123",
  "email": "user@example.com",
  "roles": ["user"],
  "iat": 1705312200,
  "exp": 1705315800
}
```

### Authentication Flow

```mermaid
sequenceDiagram
    participant C as Client
    participant A as API
    participant Auth as Auth Service

    C->>A: POST /auth/login {email, password}
    A->>Auth: Validate credentials
    Auth-->>A: User info
    A-->>C: {access_token, refresh_token, expires_in}

    Note over C: Store tokens securely

    C->>A: GET /resources (Authorization: Bearer {token})
    A->>A: Validate token
    A-->>C: 200 OK {data}

    Note over C: Token expired

    C->>A: POST /auth/refresh {refresh_token}
    A-->>C: {access_token, refresh_token, expires_in}
```

### Token Expiry Handling

| Token Type | Expiry | Storage | Refresh |
|------------|--------|---------|---------|
| Access Token | 15 minutes | Memory / httpOnly cookie | Use refresh token |
| Refresh Token | 7 days | httpOnly cookie | Re-authenticate |

---

## Rate Limiting

### Headers

| Header | Description |
|--------|-------------|
| X-RateLimit-Limit | Maximum requests allowed in window |
| X-RateLimit-Remaining | Requests remaining in current window |
| X-RateLimit-Reset | Unix timestamp when the window resets |
| Retry-After | Seconds to wait before retrying (on 429) |

### Rate Limit Tiers

| Endpoint Category | Limit | Window |
|-------------------|-------|--------|
| Default | 100 | 1 minute |
| Authentication | 10 | 1 minute |
| Search/Query | 30 | 1 minute |
| Export/Bulk | 5 | 1 hour |

### 429 Response Example

```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests, please try again later",
    "details": {
      "limit": 100,
      "window": "1 minute",
      "retry_after": 45
    }
  },
  "meta": {
    "request_id": "req_xyz789",
    "timestamp": "2024-01-15T10:30:00Z",
    "retry_after": 45
  }
}
```

**Response Headers**:
```
HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1705312245
Retry-After: 45
```

---

## Pagination

### Cursor-Based Pagination (Recommended)

Best for: Large datasets, real-time data, infinite scroll.

**Request**:
```
GET /api/v1/resources?cursor=eyJpZCI6MTAwfQ==&limit=20
```

**Response**:
```json
{
  "data": [...],
  "pagination": {
    "cursor": "eyJpZCI6MTAwfQ==",
    "next_cursor": "eyJpZCI6MTIwfQ==",
    "has_more": true,
    "limit": 20
  }
}
```

### Offset-Based Pagination

Best for: Admin panels, when total count is needed.

**Request**:
```
GET /api/v1/resources?page=2&limit=20
```

**Response**:
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "limit": 20,
    "total_count": 150,
    "total_pages": 8,
    "has_next": true,
    "has_prev": true
  }
}
```

---

## Filtering & Sorting

### Filter Parameters

| Parameter | Format | Example | Description |
|-----------|--------|---------|-------------|
| filter[field] | value | filter[status]=active | Exact match |
| filter[field][op] | value | filter[created_at][gte]=2024-01-01 | Comparison operators |

**Operators**: eq, ne, gt, gte, lt, lte, in, like

### Sort Parameters

```
GET /api/v1/resources?sort=created_at&order=desc
GET /api/v1/resources?sort=-created_at,name  # Multiple fields, - prefix for desc
```

---

## Security Headers

### Required Response Headers

```
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Content-Security-Policy: default-src 'self'
```

### CORS Headers (if applicable)

```
Access-Control-Allow-Origin: https://yourdomain.com
Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS
Access-Control-Allow-Headers: Authorization, Content-Type, X-Request-ID
Access-Control-Max-Age: 86400
```

---

## API Versioning

### URL Path Versioning (Recommended)

```
/api/v1/resources
/api/v2/resources
```

### Deprecation Policy

1. Announce deprecation 6 months before removal
2. Return `Deprecation` header with sunset date
3. Provide migration guide to new version

**Deprecation Header**:
```
Deprecation: true
Sunset: Sat, 01 Jul 2025 00:00:00 GMT
Link: </api/v2/resources>; rel="successor-version"
```

---

## Naming Conventions

**Use `snake_case` for all fields** (consistent with Python conventions).

| Element | Convention | Example |
|---------|------------|---------|
| URL paths | kebab-case (plural nouns) | /api/v1/labor-laws |
| Query params | snake_case | ?created_at_gte=2024-01-01 |
| JSON fields | snake_case | { "created_at": "..." } |
| Error codes | SCREAMING_SNAKE_CASE | VALIDATION_FAILED |

---

## Complete Example

Input: `/api-spec Query labor law articles`

Output:

## API Specification: Labor Law Articles API

### Overview
API for searching and retrieving Taiwan labor law articles, including full-text search, filtering by category, and article details.

### Base URL
`/api/v1`

### Authentication
Bearer token (JWT) required for all endpoints.

---

### Endpoints

#### 1. Search Labor Law Articles

**Endpoint**: `GET /labor-laws`

**Description**: Search and filter labor law articles with full-text search support.

**Authentication**: Required

**Rate Limit**: 30/minute

**Query Parameters**:
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| q | string | No | null | Full-text search query |
| category | string | No | null | Filter by category: working_hours, leave, wages, termination |
| cursor | string | No | null | Pagination cursor |
| limit | integer | No | 20 | Items per page (max 100) |
| sort | string | No | relevance | Sort by: relevance, article_number, updated_at |

**Request Headers**:
| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer {access_token} |
| Accept-Language | No | zh-TW (default), en-US |

**Response** (200 OK):
```json
{
  "success": true,
  "data": [
    {
      "id": "law_001",
      "article_number": "24",
      "title": "Overtime Pay Calculation",
      "category": "wages",
      "summary": "Regulations for overtime pay rates...",
      "law_name": "Labor Standards Act",
      "effective_date": "2024-01-01",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ],
  "pagination": {
    "cursor": "eyJpZCI6Imxhd18wMDEifQ==",
    "next_cursor": "eyJpZCI6Imxhd18wMjAifQ==",
    "has_more": true,
    "limit": 20,
    "total_count": 156
  },
  "meta": {
    "request_id": "req_abc123",
    "query_time_ms": 45
  }
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 400 | INVALID_REQUEST | Invalid query parameters |
| 401 | UNAUTHORIZED | Missing or invalid token |
| 429 | RATE_LIMIT_EXCEEDED | Exceeded 30 requests/minute |

---

#### 2. Get Article Details

**Endpoint**: `GET /labor-laws/{id}`

**Description**: Retrieve full details of a specific labor law article.

**Authentication**: Required

**Rate Limit**: 100/minute

**Path Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| id | string | Yes | Article ID (e.g., law_001) |

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "id": "law_001",
    "article_number": "24",
    "title": "Overtime Pay Calculation",
    "category": "wages",
    "law_name": "Labor Standards Act",
    "full_text": "For work performed beyond normal working hours...",
    "summary": "Regulations for overtime pay rates...",
    "effective_date": "2024-01-01",
    "amendment_history": [
      {
        "date": "2024-01-01",
        "description": "Updated overtime rates"
      }
    ],
    "related_articles": ["law_023", "law_024"],
    "created_at": "2020-01-01T00:00:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  },
  "meta": {
    "request_id": "req_def456"
  }
}
```

**Error Responses**:

| Status | Code | When |
|--------|------|------|
| 404 | RESOURCE_NOT_FOUND | Article ID does not exist |

---

### Data Models

#### LaborLawArticle
| Field | Type | Nullable | Description |
|-------|------|----------|-------------|
| id | string | No | Unique identifier (law_xxx) |
| article_number | string | No | Official article number |
| title | string | No | Article title |
| category | enum | No | working_hours, leave, wages, termination, safety |
| law_name | string | No | Parent law name |
| full_text | string | No | Complete article text |
| summary | string | Yes | Brief summary |
| effective_date | date | No | When the article became effective |
| amendment_history | array | No | List of amendments |
| related_articles | array | No | Related article IDs |
| created_at | datetime | No | Record creation time |
| updated_at | datetime | Yes | Last update time |

---

### Notes
- All dates are in ISO 8601 format (UTC)
- Article content is in Traditional Chinese by default
- Legal disclaimer should be displayed when showing article content
