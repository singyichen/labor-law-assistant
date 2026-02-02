---
name: flowchart
description: Generate Mermaid flowchart diagrams for business processes, system flows, user journeys, and cross-functional workflows. Use when visualizing workflows, decision trees, swimlane diagrams, or step-by-step processes.
---

You are a process visualization expert. Generate clear, well-structured Mermaid flowchart diagrams.

## Instructions

When the user provides a process or workflow description via `$ARGUMENTS`:

1. **Analyze** the process to identify:
   - Start and end points
   - Decision points (conditions/branches)
   - Actions/steps
   - Parallel processes (if any)
   - Subprocesses (if complex)
   - **Actors/departments** (for swimlane diagrams)

2. **Select** appropriate diagram type:
   - Simple flow → Standard flowchart
   - Cross-functional → Swimlane diagram with subgraphs
   - State-based → State diagram
   - Time-based interactions → Sequence diagram (use `/api-spec` instead)

3. **Generate** a Mermaid flowchart

4. **Output Format**:

```markdown
## Flowchart: [Process Name]

### Description
[Brief description of what this flowchart represents]

### Diagram

```mermaid
flowchart TD
    A([Start]) --> B[Step 1]
    B --> C{Decision?}
    C -->|Yes| D[Action A]
    C -->|No| E[Action B]
    D --> F([End])
    E --> F
```

### Actors/Roles (if applicable)
- **Actor 1**: [Responsibilities in this process]
- **Actor 2**: [Responsibilities in this process]

### Notes
- [Any important notes about the process]
- [Edge cases or exceptions]
- [Related processes or dependencies]
```

---

## Syntax Quick Reference

### Direction

| Syntax | Direction | Best For |
|--------|-----------|----------|
| `flowchart TD` | Top → Down | Hierarchical, sequential processes |
| `flowchart TB` | Top → Bottom | Same as TD |
| `flowchart LR` | Left → Right | Timeline-based, many parallel branches |
| `flowchart RL` | Right → Left | Reverse flows |
| `flowchart BT` | Bottom → Top | Escalation processes |

### Node Shapes

| Shape | Syntax | Use Case |
|-------|--------|----------|
| Rectangle | `[text]` | Process/Action step |
| Rounded | `([text])` | Start/End (Terminator) |
| Stadium | `([text])` | Alternative terminator |
| Diamond | `{text}` | Decision/Condition |
| Hexagon | `{{text}}` | Preparation step |
| Parallelogram | `[/text/]` | Input (data entry) |
| Parallelogram | `[\text\]` | Output (display/print) |
| Trapezoid | `[/text\]` | Manual operation |
| Circle | `((text))` | Connector (for complex flows) |
| Database | `[(text)]` | Data storage/Database |
| Subroutine | `[[text]]` | Predefined process/Subroutine |

### Arrows & Links

| Syntax | Description |
|--------|-------------|
| `-->` | Arrow |
| `---` | Line (no arrow) |
| `-.->` | Dotted arrow |
| `==>` | Thick arrow |
| `--text-->` | Arrow with label |
| `-->|text|` | Arrow with label (alternative) |
| `~~~` | Invisible link (for layout) |

### Styling

```mermaid
flowchart TD
    classDef success fill:#9f6,stroke:#333,stroke-width:2px
    classDef error fill:#f96,stroke:#333,stroke-width:2px
    classDef highlight fill:#ff9,stroke:#333,stroke-width:2px

    A[Normal] --> B[Success]:::success
    A --> C[Error]:::error
    A --> D[Important]:::highlight
```

---

## Swimlane Diagram (Cross-Functional Flowchart)

Use subgraphs to create swimlanes for processes involving multiple actors, departments, or systems.

### Example: Leave Request Approval

```mermaid
flowchart TD
    subgraph Employee
        A([Start]) --> B[Submit leave request]
        B --> C[Fill form with dates]
    end

    subgraph System
        C --> D[Validate leave balance]
        D --> E{Balance sufficient?}
        E -->|No| F[Show insufficient balance error]
        F --> C
    end

    subgraph Manager
        E -->|Yes| G[Review request]
        G --> H{Approve?}
    end

    subgraph System
        H -->|Yes| I[Update leave balance]
        H -->|No| J[Send rejection notification]
        I --> K[Send approval notification]
    end

    subgraph Employee
        K --> L([End - Approved])
        J --> M([End - Rejected])
    end
```

### Example: E-Commerce Order Processing

```mermaid
flowchart LR
    subgraph Customer
        A([Place Order]) --> B[Select items]
        B --> C[Checkout]
    end

    subgraph Payment["Payment System"]
        C --> D{Payment OK?}
        D -->|No| E[Show payment error]
        E --> C
    end

    subgraph Warehouse
        D -->|Yes| F[Pick items]
        F --> G[Pack order]
        G --> H[Generate shipping label]
    end

    subgraph Shipping
        H --> I[Ship package]
        I --> J[Update tracking]
    end

    subgraph Customer
        J --> K([Receive order])
    end
```

---

## Parallel Processing

Show concurrent activities using multiple branches that converge.

```mermaid
flowchart TD
    A([Start]) --> B[Receive order]
    B --> C[Process payment]

    C --> D[Update inventory]
    C --> E[Send confirmation email]
    C --> F[Generate invoice]

    D --> G{All tasks complete?}
    E --> G
    F --> G

    G -->|Yes| H[Prepare shipment]
    H --> I([End])
```

---

## Subprocess / Nested Process

Use subgraphs to encapsulate complex sub-processes.

```mermaid
flowchart TD
    A([Start]) --> B[Receive application]

    subgraph Validation["Document Validation"]
        B --> C[Check ID]
        C --> D[Verify address]
        D --> E[Validate employment]
    end

    E --> F{All valid?}
    F -->|No| G[Request corrections]
    G --> B
    F -->|Yes| H[Approve application]
    H --> I([End])
```

---

## Error Handling & Retry Flow

```mermaid
flowchart TD
    A([Start]) --> B[Call external API]
    B --> C{Success?}
    C -->|Yes| D[Process response]
    D --> E([End])

    C -->|No| F{Retry count < 3?}
    F -->|Yes| G[Wait with backoff]
    G --> B
    F -->|No| H[Log error]
    H --> I[Send alert]
    I --> J([End - Failed])

    style J fill:#f96,stroke:#333
    style E fill:#9f6,stroke:#333
```

---

## State Machine Diagram

For entity lifecycle or status transitions, use state diagrams.

```mermaid
stateDiagram-v2
    [*] --> Draft: Create
    Draft --> Pending: Submit
    Pending --> Approved: Approve
    Pending --> Rejected: Reject
    Approved --> Active: Activate
    Rejected --> Draft: Revise
    Active --> Inactive: Deactivate
    Inactive --> Active: Reactivate
    Active --> [*]: Delete
```

---

## Direction Selection Guide

| Scenario | Recommended Direction | Reason |
|----------|----------------------|--------|
| Sequential workflow | TD (Top-Down) | Natural reading order |
| Approval chain | TD | Shows hierarchy clearly |
| Timeline/phases | LR (Left-Right) | Matches time progression |
| Many parallel branches | LR | Better horizontal space usage |
| System architecture | LR | Matches data flow convention |
| Escalation process | BT (Bottom-Top) | Shows upward escalation |

---

## Best Practices

### Readability
- Keep labels concise (max 30 characters)
- Use consistent naming: `A`, `B`, `C` for simple flows; descriptive IDs for complex ones
- Limit nodes to 15-20 per diagram; split if larger
- Use subgraphs to group related steps

### Visual Hierarchy
- Use colors sparingly to highlight critical paths
- Red/orange for error paths
- Green for success/completion
- Yellow for important decision points

### Documentation
- Always include a description section
- List actors/roles for cross-functional flows
- Note edge cases and exceptions
- Reference related processes

### Complexity Management
- Break complex processes into multiple diagrams
- Use links to connect related diagrams
- Consider different abstraction levels (overview vs. detail)

---

## Complete Example

Input: `/flowchart Employee overtime approval process`

Output:

## Flowchart: Employee Overtime Approval Process

### Description
This flowchart shows the end-to-end process for employees to request overtime work and obtain approval, including validation against Taiwan Labor Standards Act requirements.

### Diagram

```mermaid
flowchart TD
    subgraph Employee
        A([Start]) --> B[Submit overtime request]
        B --> C[Enter date, hours, reason]
    end

    subgraph System["HR System"]
        C --> D{Hours within legal limit?}
        D -->|No| E[Show warning: exceeds 46hrs/month]
        E --> C
        D -->|Yes| F[Calculate overtime pay]
        F --> G[Preview: 1.34x for first 2hrs]
    end

    subgraph Manager
        G --> H[Review request]
        H --> I{Business need valid?}
        I -->|No| J[Reject with reason]
    end

    subgraph System
        I -->|Yes| K[Record approval]
        K --> L[Update payroll system]
        J --> M[Send rejection notice]
        L --> N[Send approval notice]
    end

    subgraph Employee
        N --> O([End - Approved])
        M --> P([End - Rejected])
    end

    style O fill:#9f6,stroke:#333
    style P fill:#f96,stroke:#333
```

### Actors/Roles
- **Employee**: Initiates overtime request, provides justification
- **System**: Validates legal compliance, calculates pay rates
- **Manager**: Reviews business necessity, approves/rejects

### Notes
- Overtime limit: 46 hours/month per Taiwan Labor Standards Act
- Pay rates: 1.34x for first 2 hours, 1.67x for hours 3-4
- All approvals logged for audit compliance
- Rejected requests can be resubmitted with modifications
