---
name: system-to-diagrams
description: Converts system interaction flows into consistent architecture diagrams (C4, sequence, component, data flow). Use when documenting architecture, preparing design reviews, onboarding teams, or when the user mentions diagrams, architecture visualization, or system design.
---

# System Flow to Architecture Diagrams

## Purpose

Convert interaction flows into consistent, professional architecture diagrams for documentation and communication.

## When to Use

- Design documentation and architecture reviews
- Team onboarding materials
- Technical proposal presentations
- System design discussions
- API documentation
- Incident postmortems showing system behavior

## Diagram Types

### 1. C4 Model (Context, Containers, Components, Code)

Progressive levels of detail for system architecture.

#### Level 1: Context Diagram
Shows system in relation to users and external systems.

```mermaid
graph TB
    User[User]
    System[E-commerce Platform]
    Payment[Payment Gateway]
    Email[Email Service]
    
    User -->|Places orders| System
    System -->|Processes payments| Payment
    System -->|Sends notifications| Email
```

#### Level 2: Container Diagram
Shows major technology choices and how they communicate.

```mermaid
graph TB
    subgraph ecommerce [E-commerce Platform]
        WebApp[Web Application<br/>React]
        API[API Server<br/>Node.js]
        DB[(Database<br/>PostgreSQL)]
        Cache[(Cache<br/>Redis)]
    end
    
    User[User] -->|HTTPS| WebApp
    WebApp -->|REST/JSON| API
    API -->|SQL| DB
    API -->|Read/Write| Cache
    API -->|HTTPS| Payment[Payment Gateway]
```

#### Level 3: Component Diagram
Shows components within a container.

```mermaid
graph TB
    subgraph apiserver [API Server]
        Auth[Auth Component]
        Order[Order Service]
        Inventory[Inventory Service]
        Payment[Payment Service]
    end
    
    Request[HTTP Request] --> Auth
    Auth --> Order
    Order --> Inventory
    Order --> Payment
```

### 2. Sequence Diagrams
Shows interactions over time.

```mermaid
sequenceDiagram
    actor User
    participant Gateway as API Gateway
    participant Auth as Auth Service
    participant Order as Order Service
    participant Payment as Payment Service
    participant DB as Database
    
    User->>Gateway: POST /orders
    Gateway->>Auth: Validate token
    Auth-->>Gateway: Token valid
    Gateway->>Order: Create order
    Order->>DB: Check inventory
    DB-->>Order: In stock
    Order->>Payment: Process payment
    Payment-->>Order: Payment success
    Order->>DB: Save order
    Order-->>Gateway: Order created
    Gateway-->>User: 201 Created
```

### 3. Data Flow Diagrams
Shows how data moves through the system.

```mermaid
flowchart LR
    User[User Input] --> Validation[Validation Layer]
    Validation --> Transform[Data Transform]
    Transform --> BusinessLogic[Business Logic]
    BusinessLogic --> DataAccess[Data Access Layer]
    DataAccess --> Database[(Database)]
    
    Database --> Cache[(Cache)]
    Cache --> APIResponse[API Response]
    APIResponse --> User
```

### 4. Component Architecture
Shows relationships between major components.

```mermaid
graph TB
    subgraph frontend [Frontend Layer]
        Web[Web App]
        Mobile[Mobile App]
    end
    
    subgraph apigateway [API Gateway Layer]
        Gateway[API Gateway]
        RateLimit[Rate Limiter]
    end
    
    subgraph services [Service Layer]
        UserSvc[User Service]
        OrderSvc[Order Service]
        ProductSvc[Product Service]
    end
    
    subgraph data [Data Layer]
        UserDB[(User DB)]
        OrderDB[(Order DB)]
        ProductDB[(Product DB)]
        Cache[(Redis Cache)]
    end
    
    Web --> Gateway
    Mobile --> Gateway
    Gateway --> RateLimit
    RateLimit --> UserSvc
    RateLimit --> OrderSvc
    RateLimit --> ProductSvc
    
    UserSvc --> UserDB
    OrderSvc --> OrderDB
    ProductSvc --> ProductDB
    UserSvc --> Cache
    OrderSvc --> Cache
```

### 5. Deployment Architecture
Shows physical/cloud infrastructure.

```mermaid
graph TB
    subgraph aws [AWS Cloud]
        subgraph vpc [VPC]
            subgraph public [Public Subnet]
                ALB[Application Load Balancer]
            end
            
            subgraph private [Private Subnet]
                ECS1[ECS Service 1]
                ECS2[ECS Service 2]
            end
            
            subgraph data [Data Subnet]
                RDS[(RDS PostgreSQL)]
                ElastiCache[(ElastiCache Redis)]
            end
        end
        
        CloudFront[CloudFront CDN]
        S3[S3 Static Assets]
    end
    
    Internet[Internet] --> CloudFront
    CloudFront --> S3
    CloudFront --> ALB
    ALB --> ECS1
    ALB --> ECS2
    ECS1 --> RDS
    ECS2 --> RDS
    ECS1 --> ElastiCache
    ECS2 --> ElastiCache
```

## Example: Order Processing System

### Input Flow Description

```
User submits order through web app:
1. User fills order form → Frontend validates
2. Frontend sends to API Gateway → Gateway checks rate limits
3. Gateway routes to Auth Service → Validates JWT token
4. Auth approves → Gateway forwards to Order Service
5. Order Service checks inventory → Queries Inventory DB
6. If available → Order Service calls Payment Service
7. Payment Service → Calls external Payment Provider (Stripe)
8. Payment succeeds → Order Service saves to Order DB
9. Order Service publishes event → Event bus (Kafka)
10. Notification Service consumes event → Sends email via SendGrid
11. Response propagates back → User receives confirmation
```

### Output: Complete Diagram Set

#### 1. Context Diagram (Highest Level)

```mermaid
graph TB
    User[Customer]
    Admin[Admin User]
    System[Order Management System]
    Stripe[Stripe Payment]
    SendGrid[SendGrid Email]
    Analytics[Analytics Platform]
    
    User -->|Places orders| System
    Admin -->|Manages orders| System
    System -->|Processes payments| Stripe
    System -->|Sends notifications| SendGrid
    System -->|Sends events| Analytics
```

#### 2. Container Diagram (Technology Stack)

```mermaid
graph TB
    User[User<br/>Web Browser]
    
    subgraph system [Order Management System]
        WebApp[Web Application<br/>React + TypeScript]
        APIGateway[API Gateway<br/>Kong]
        AuthService[Auth Service<br/>Node.js]
        OrderService[Order Service<br/>Python/FastAPI]
        InventoryService[Inventory Service<br/>Go]
        NotificationService[Notification Service<br/>Node.js]
        
        OrderDB[(Order Database<br/>PostgreSQL)]
        InventoryDB[(Inventory Database<br/>PostgreSQL)]
        Cache[(Cache<br/>Redis)]
        EventBus[Event Bus<br/>Kafka]
    end
    
    Stripe[Stripe API]
    SendGrid[SendGrid API]
    
    User -->|HTTPS| WebApp
    WebApp -->|REST/JSON| APIGateway
    APIGateway --> AuthService
    APIGateway --> OrderService
    APIGateway --> InventoryService
    
    OrderService -->|SQL| OrderDB
    InventoryService -->|SQL| InventoryDB
    OrderService -->|Cache| Cache
    
    OrderService -->|HTTPS| Stripe
    OrderService -->|Publish| EventBus
    NotificationService -->|Subscribe| EventBus
    NotificationService -->|HTTPS| SendGrid
```

#### 3. Sequence Diagram (Order Flow)

```mermaid
sequenceDiagram
    actor User
    participant WebApp
    participant APIGateway
    participant Auth
    participant OrderSvc as Order Service
    participant InventorySvc as Inventory Service
    participant PaymentSvc as Payment Service
    participant Stripe
    participant EventBus as Kafka
    participant NotifSvc as Notification Service
    participant SendGrid
    
    User->>WebApp: Fill order form
    WebApp->>WebApp: Validate input
    WebApp->>APIGateway: POST /api/orders
    APIGateway->>Auth: Verify JWT token
    Auth-->>APIGateway: Token valid
    
    APIGateway->>OrderSvc: Create order request
    OrderSvc->>InventorySvc: Check stock availability
    InventorySvc-->>OrderSvc: Items in stock
    
    OrderSvc->>PaymentSvc: Process payment
    PaymentSvc->>Stripe: Charge card
    Stripe-->>PaymentSvc: Payment success
    PaymentSvc-->>OrderSvc: Payment confirmed
    
    OrderSvc->>OrderSvc: Save order to DB
    OrderSvc->>EventBus: Publish OrderCreated event
    OrderSvc-->>APIGateway: Order created (201)
    APIGateway-->>WebApp: Success response
    WebApp-->>User: Show confirmation
    
    EventBus->>NotifSvc: OrderCreated event
    NotifSvc->>SendGrid: Send confirmation email
    SendGrid-->>NotifSvc: Email sent
```

#### 4. Component Diagram (Order Service Internals)

```mermaid
graph TB
    subgraph orderservice [Order Service]
        API[REST API Layer]
        Validation[Validation]
        OrderLogic[Order Business Logic]
        PaymentLogic[Payment Logic]
        EventPublisher[Event Publisher]
        Repository[Data Repository]
    end
    
    Request[HTTP Request] --> API
    API --> Validation
    Validation --> OrderLogic
    OrderLogic --> PaymentLogic
    PaymentLogic --> ExternalPayment[Payment Service]
    OrderLogic --> Repository
    Repository --> Database[(Database)]
    OrderLogic --> EventPublisher
    EventPublisher --> Kafka[Kafka]
```

## Best Practices

### Use Clear Labels

```mermaid
graph LR
    A[User Service<br/>Node.js<br/>Port: 3000]
    B[(User Database<br/>PostgreSQL<br/>RDS)]
    A -->|SQL queries<br/>Connection pool: 20| B
```

### Show Technology Stack

Include:
- Programming language
- Framework
- Database type
- Communication protocol
- Key configuration

### Indicate Data Flow Direction

```mermaid
graph LR
    A[Service A] -->|Sync request<br/>REST/JSON| B[Service B]
    B -.->|Async event<br/>Kafka| C[Service C]
```

Use:
- Solid arrows `-->` for synchronous calls
- Dotted arrows `-.->` for asynchronous/events
- Bidirectional `<-->` when both services call each other

### Group Related Components

```mermaid
graph TB
    subgraph frontend [Frontend Layer]
        Web[Web App]
        Mobile[Mobile App]
    end
    
    subgraph backend [Backend Services]
        API1[Service 1]
        API2[Service 2]
    end
    
    frontend --> backend
```

### Show Failure Paths

```mermaid
sequenceDiagram
    User->>Service: Request
    Service->>Database: Query
    alt Success
        Database-->>Service: Data
        Service-->>User: 200 OK
    else Database unavailable
        Database--xService: Timeout
        Service->>Cache: Try cache
        Cache-->>Service: Cached data
        Service-->>User: 200 OK (cached)
    else Cache miss
        Cache--xService: Miss
        Service-->>User: 503 Service Unavailable
    end
```

## Diagram Selection Guide

| Scenario | Best Diagram Type |
|----------|------------------|
| System overview for executives | Context (C4 Level 1) |
| Technology decisions | Container (C4 Level 2) |
| Internal service design | Component (C4 Level 3) |
| API request/response flow | Sequence diagram |
| Event-driven architecture | Sequence + data flow |
| Data transformation | Data flow diagram |
| Infrastructure setup | Deployment diagram |
| Database schema | Entity relationship diagram |
| Authentication flow | Sequence diagram |
| Error handling | Sequence with alt/opt blocks |

## Tools

### Mermaid (Recommended)
- Text-based, version control friendly
- Renders in Markdown, GitHub, GitLab
- Good for simple to moderate diagrams
- Syntax: [Mermaid Documentation](https://mermaid.js.org/)

### PlantUML
- More powerful than Mermaid
- Better for complex diagrams
- Requires Java runtime
- Syntax: [PlantUML Documentation](https://plantuml.com/)

### Draw.io (Diagrams.net)
- Visual editor (drag and drop)
- Export as PNG, SVG, XML
- Good for presentations
- Tool: [Draw.io](https://app.diagrams.net/)

### Lucidchart
- Professional diagramming tool
- Team collaboration features
- Good for formal documentation
- Tool: [Lucidchart](https://www.lucidchart.com/)

## Resources

### Architecture Patterns
- [C4 Model](https://c4model.com/) - Standard for architecture diagrams
- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/) - Cloud diagrams
- [Azure Architecture Icons](https://learn.microsoft.com/en-us/azure/architecture/icons/)

### Diagram Best Practices
- [Simon Brown on Visualizing Software Architecture](https://www.youtube.com/watch?v=x2-rSnhpw0g)
- [Architecture Diagrams as Code](https://www.thoughtworks.com/insights/articles/architecture-diagrams-as-code)

### Learning Resources
- [Mermaid Live Editor](https://mermaid.live/) - Try diagrams online
- [PlantUML Examples](https://real-world-plantuml.com/) - Real-world examples

## Tips

1. **Start simple**: Begin with context, add detail progressively
2. **Consistent notation**: Use same shapes/colors for same concepts
3. **Limit scope**: One diagram = one story
4. **Add legends**: Explain symbols, colors, line styles
5. **Version control**: Store diagrams as code when possible
6. **Keep updated**: Outdated diagrams worse than no diagrams
7. **Audience matters**: Technical depth varies by audience

## Quick Checklist

- [ ] Diagram type appropriate for audience
- [ ] All components labeled clearly
- [ ] Technology stack indicated
- [ ] Communication protocols shown
- [ ] Data flow direction clear
- [ ] Related components grouped
- [ ] Legend provided (if needed)
- [ ] Consistent notation throughout
- [ ] Text readable (not too small)
- [ ] Failure paths shown (if relevant)
