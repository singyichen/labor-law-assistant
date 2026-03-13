# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]  
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]

## Legal Compliance *(if feature involves legal content)*

<!--
  Include this section when the feature touches labor law content,
  legal calculations, or legal advice display.
-->

### Legal Requirements

- Applicable laws: [e.g., Labor Standards Act, Act of Gender Equality in Employment]
- Specific articles referenced: [e.g., LSA §24 (overtime), LSA §38 (annual leave)]
- Legal accuracy validation: [How will correctness be verified? e.g., cross-check with MOL calculator]

### Legal Calculation Logic *(if feature involves calculations)*

<!--
  Document the exact calculation formulas, citing specific law articles.
  Include worked examples for validation.
-->

- **Calculation**: [e.g., Overtime pay for weekdays]
  - **Formula**: [e.g., hourly_wage × 1.34 for first 2 hours, hourly_wage × 1.67 for next 2 hours]
  - **Legal basis**: [e.g., LSA §24, Paragraph 1]
  - **Example**: [e.g., Monthly salary 30,000 → hourly wage 125 → 2h OT = 125 × 1.34 × 2 = 335]
  - **Edge cases**: [e.g., Part-time workers, foreign workers, workers on probation]

### Disclaimer Requirements

- LLM responses MUST include `confidence_score` and `source_articles`
- Confidence < 0.7 or empty sources → mandatory disclaimer
- Disclaimer text: [Define or reference standard disclaimer template]

## Legal Module Testing *(if feature involves legal calculations)*

<!--
  Legal modules require 95% test coverage (vs. 80% general).
  Include golden dataset validation for calculators.
-->

### Test Requirements

- Coverage target: 95% minimum
- Golden dataset: [Source of truth, e.g., MOL online calculator results]
- Cross-validation cases: [List specific scenarios to validate against government tools]

| Scenario | Input | Expected Output | Legal Basis | Source |
|----------|-------|-----------------|-------------|--------|
| [e.g., Weekday OT 2h] | [e.g., salary=30000, hours=2] | [e.g., 335] | [LSA §24] | [MOL calculator] |

## Localization *(if feature involves user-facing content)*

<!--
  Include when the feature has user-visible text or legal terminology.
-->

- UI language: Traditional Chinese (zh-TW)
- Legal terminology: Official MOL terminology (勞動部官方用語)
- Technical terms: Retain English form (e.g., API, JWT, P-value)
- Date format: YYYY-MM-DD (ISO 8601)
- Currency format: NT$ with thousands separator (e.g., NT$30,000)

## Cost Estimation *(if feature involves AI/RAG)*

<!--
  Include when the feature uses LLM calls, embedding generation, or vector search.
  Helps estimate operational costs before implementation.
-->

### AI Resource Usage

| Operation | Provider | Model | Est. Calls/Day | Est. Cost/Day |
|-----------|----------|-------|-----------------|---------------|
| [e.g., Legal Q&A] | [Anthropic] | [Claude Sonnet 4.5] | [500] | [~$X.XX] |
| [e.g., Embedding] | [OpenAI] | [text-embedding-3-large] | [100] | [~$X.XX] |
| [e.g., Fallback] | [OpenAI] | [GPT-4o-mini] | [50] | [~$X.XX] |

### Caching Strategy

- Cache key pattern: [e.g., `qa:hash:{question_hash}:{context_hash}`]
- TTL: [e.g., 1 hour]
- Expected cache hit rate: [e.g., >60%]
- Estimated cost savings: [e.g., 40% reduction in LLM calls]
