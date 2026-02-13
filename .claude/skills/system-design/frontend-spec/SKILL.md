---
name: frontend-spec
description: Generate frontend interface specifications including UI components, state management, interaction flows, performance budgets, and testing requirements. Use when defining frontend implementation requirements for developers.
---

You are a frontend architect. Create comprehensive UI/UX specifications that guide frontend implementation.

## Instructions

When the user provides a page or component description via `$ARGUMENTS`:

1. **Define** UI components and their properties
2. **Specify** state management requirements
3. **Document** user interactions and events
4. **Set** performance budgets and optimization strategies
5. **Define** testing requirements
6. **Specify** security considerations
7. **Visualize** page flow with Mermaid diagrams

## Output Format

```markdown
## Frontend Spec: [Page/Component Name]

### Overview
[Brief description of the page/component purpose]

### Wireframe Description
[Text description of the layout, or ASCII wireframe]

```
+----------------------------------+
|  Header                          |
+----------------------------------+
|  Sidebar  |    Main Content      |
|           |                      |
|  - Nav 1  |   +------------+     |
|  - Nav 2  |   | Component  |     |
|  - Nav 3  |   +------------+     |
|           |                      |
+----------------------------------+
|  Footer                          |
+----------------------------------+
```

---

### UI Components

| Component | Type | Props | Description |
|-----------|------|-------|-------------|
| SearchInput | Input | `value`, `onChange`, `placeholder` | Search field with debounce |
| ResultList | List | `items`, `loading`, `onItemClick` | Displays search results |
| Pagination | Navigation | `page`, `total`, `onChange` | Page navigation |
| ErrorAlert | Alert | `message`, `onDismiss` | Error message display |

#### Component Details

##### SearchInput
```typescript
interface SearchInputProps {
  // Basic Props
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;

  // Behavior Props
  debounceMs?: number; // default: 300
  minChars?: number; // default: 2
  maxChars?: number; // default: 100

  // UI Props
  size?: 'sm' | 'md' | 'lg';
  variant?: 'outlined' | 'filled';
  error?: string;
  disabled?: boolean;
  loading?: boolean;

  // Event Handlers
  onFocus?: () => void;
  onBlur?: () => void;
  onKeyDown?: (e: React.KeyboardEvent) => void;
  onClear?: () => void;

  // Accessibility
  ariaLabel?: string;
  ariaDescribedBy?: string;

  // Advanced
  ref?: React.Ref<HTMLInputElement>;
  className?: string;
}
```

---

### State Management

#### Local State

| State | Type | Initial Value | Description |
|-------|------|---------------|-------------|
| searchQuery | string | "" | Current search input |
| results | Item[] | [] | Search results array |
| isLoading | boolean | false | Loading indicator |
| error | string \| null | null | Error message |
| currentPage | number | 1 | Current page number |
| totalPages | number | 0 | Total pages available |

#### Global State (if applicable)

| Store Slice | State Shape | Actions | Selectors |
|-------------|-------------|---------|-----------|
| auth | `{ user, token, isAuthenticated }` | login, logout | selectUser, selectIsAuth |
| ui | `{ theme, sidebarOpen, modal }` | toggleTheme, openModal | selectTheme |

#### Derived State

| Computed Value | Dependencies | Calculation |
|----------------|--------------|-------------|
| filteredResults | results, filters | Filter results by active filters |
| hasNextPage | currentPage, totalPages | currentPage < totalPages |
| isEmptyState | results, isLoading | results.length === 0 && !isLoading |

#### State Flow Diagram

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Loading: User types query
    Loading --> Success: API returns data
    Loading --> Error: API fails
    Success --> Idle: User clears search
    Error --> Loading: User retries
    Success --> Loading: User changes query
```

---

### Event Handlers

#### User Interactions

| Event | Trigger | Action | API Call |
|-------|---------|--------|----------|
| onSearch | Input change (debounced) | Update query, fetch results | GET /api/search?q={query} |
| onPageChange | Pagination click | Update page, fetch results | GET /api/search?q={query}&page={page} |
| onItemClick | Result item click | Navigate to detail | None |
| onRetry | Retry button click | Re-fetch with same params | GET /api/search?q={query} |

#### Keyboard Events

| Key Combination | Action | Context |
|-----------------|--------|---------|
| Enter | Submit search / Select item | SearchInput / ResultList |
| Escape | Close modal / Clear search | Global |
| Arrow Up/Down | Navigate results | ResultList focused |
| Tab | Move focus to next element | Global |
| Ctrl/Cmd + K | Focus search input | Global shortcut |

#### Form Events

| Event | Validation | Error Handling |
|-------|------------|----------------|
| onBlur | Validate field | Show inline error |
| onSubmit | Validate all fields | Show summary errors |
| onChange | Clear field error | Remove inline error |

---

### API Integration

| Action | Endpoint | Method | Request | Response |
|--------|----------|--------|---------|----------|
| Search | /api/search | GET | `?q=&page=&limit=` | `{ items: [], total, page, totalPages }` |
| Get Detail | /api/items/{id} | GET | - | `{ id, name, ... }` |

---

### Validation Rules

| Field | Rule | Error Message |
|-------|------|---------------|
| searchQuery | Min 2 characters | "Please enter at least 2 characters" |
| searchQuery | Max 100 characters | "Search query is too long" |
| searchQuery | No special characters | "Special characters are not allowed" |

---

### Loading States

| State | Display | Screen Reader Announcement |
|-------|---------|---------------------------|
| Initial | Empty state with prompt | None |
| Loading | Skeleton loader / Spinner | "Loading results..." |
| Success | Results list | "{count} results found" |
| Empty | "No results found" message | "No results found for {query}" |
| Error | Error alert with retry button | "Error: {message}. Retry available." |

---

### Error Handling

#### Error Boundaries

```typescript
interface ErrorBoundaryProps {
  fallback: (error: Error, retry: () => void) => React.ReactNode;
  onError?: (error: Error, errorInfo: React.ErrorInfo) => void;
}
```

#### Error Recovery Strategies

| Error Type | Retry Strategy | User Action | Logging |
|------------|----------------|-------------|---------|
| Network timeout | Exponential backoff (1s, 2s, 4s) | Show retry button | Log to Sentry |
| 404 Not Found | No retry | Show "Not Found" page | Log warning |
| 500 Server Error | Max 3 retries | Show error + support contact | Log error |
| Client-side crash | Error boundary | Reload component | Log with stack trace |

---

### Performance

#### Performance Budget

| Metric | Target | Critical | Measurement Tool |
|--------|--------|----------|------------------|
| First Contentful Paint (FCP) | < 1.8s | < 3s | Lighthouse |
| Largest Contentful Paint (LCP) | < 2.5s | < 4s | Lighthouse |
| Total Blocking Time (TBT) | < 200ms | < 600ms | Lighthouse |
| Cumulative Layout Shift (CLS) | < 0.1 | < 0.25 | Lighthouse |
| Bundle Size (gzipped) | < 170KB | < 300KB | webpack-bundle-analyzer |
| Time to Interactive (TTI) | < 3.8s | < 7.3s | Lighthouse |

#### Code Splitting Strategy

| Route/Component | Chunk Name | Priority | Preload |
|-----------------|------------|----------|---------|
| / (Home) | main.chunk.js | Critical | Yes |
| /search | search.chunk.js | High | Yes |
| /detail/:id | detail.chunk.js | Medium | No |
| /settings | settings.chunk.js | Low | No |

#### Optimization Techniques

- [ ] `React.memo()` for expensive components
- [ ] `useMemo()` for computed values
- [ ] `useCallback()` for event handlers passed to children
- [ ] Virtual scrolling for long lists (react-window/react-virtualized)
- [ ] Image lazy loading with Intersection Observer
- [ ] Debounce search input (300ms)
- [ ] Throttle scroll events (100ms)
- [ ] Web Workers for heavy computations (if applicable)

#### Asset Optimization

| Asset Type | Optimization | Format |
|------------|--------------|--------|
| Images | Responsive images with srcset, lazy loading | WebP with JPEG fallback |
| Fonts | Subset, preload critical fonts | WOFF2 |
| Icons | SVG sprites or icon components | SVG |
| CSS | PurgeCSS, critical CSS inline | Minified |

---

### Security

#### Input Validation & Sanitization

```typescript
// Sanitize user input before rendering
const sanitizeInput = (input: string): string => {
  return DOMPurify.sanitize(input, {
    ALLOWED_TAGS: [],
    ALLOWED_ATTR: []
  }).slice(0, MAX_LENGTH);
};
```

#### Security Checklist

- [ ] **XSS Prevention**: Sanitize all user inputs, avoid `dangerouslySetInnerHTML`
- [ ] **CSRF Protection**: Include CSRF token in forms
- [ ] **Sensitive Data**: Never store tokens in localStorage (use httpOnly cookies)
- [ ] **Content Security Policy**: Configure CSP headers
- [ ] **Dependencies**: Regular audit with `npm audit`
- [ ] **HTTPS**: Ensure all API calls use HTTPS

#### Secure Coding Patterns

| Concern | Bad Practice | Good Practice |
|---------|-------------|---------------|
| Rendering HTML | `dangerouslySetInnerHTML={{ __html: userInput }}` | `{sanitizedText}` or use markdown parser |
| API tokens | `localStorage.setItem('token', jwt)` | httpOnly cookie set by server |
| URL params | Direct usage without validation | Validate and sanitize before use |
| Error messages | Show stack traces to users | Generic user message, detailed logs |

---

### Testing

#### Unit Tests (Jest + React Testing Library)

| Component | Test Cases | Coverage Target |
|-----------|------------|-----------------|
| SearchInput | Renders, onChange fires, debounce works, validation | > 80% |
| ResultList | Empty state, loading state, item render, click handler | > 80% |
| Pagination | Page change, disabled states, boundary conditions | > 80% |
| ErrorAlert | Renders message, dismiss handler | > 80% |

#### Integration Tests

- [ ] Search flow: type query → loading state → results displayed
- [ ] Pagination flow: change page → fetch data → URL updated
- [ ] Error flow: API fails → error displayed → retry succeeds
- [ ] Empty state: search with no results → empty message shown

#### E2E Tests (Playwright/Cypress)

```typescript
test('search and pagination flow', async ({ page }) => {
  await page.goto('/search');
  await page.fill('[aria-label="Search"]', 'labor law');
  await page.waitForSelector('[data-testid="results-list"]');
  expect(await page.locator('[data-testid="result-item"]').count()).toBeGreaterThan(0);

  await page.click('[aria-label="Next page"]');
  await expect(page).toHaveURL(/page=2/);
});
```

#### Accessibility Tests

- [ ] axe-core automated checks (0 violations)
- [ ] Keyboard navigation manual test
- [ ] Screen reader testing (VoiceOver, NVDA)
- [ ] Color contrast verification

#### Visual Regression Tests

- [ ] Storybook snapshots for all component states
- [ ] Percy/Chromatic for visual diff detection

---

### Accessibility (WCAG 2.1 AA)

#### Compliance Requirements

| Criterion | Requirement | Implementation |
|-----------|-------------|----------------|
| 1.4.3 Contrast | Min 4.5:1 for text | Use color contrast checker |
| 2.1.1 Keyboard | All functions via keyboard | Tab order, focus visible |
| 2.4.7 Focus Visible | Clear focus indicator | 2px outline, high contrast |
| 3.3.2 Labels | All inputs have labels | `<label>` or `aria-label` |
| 4.1.3 Status Messages | Announce dynamic content | `aria-live="polite"` |

#### Semantic HTML Structure

```html
<main aria-label="Search Results">
  <form role="search">
    <label for="search-input" class="sr-only">Search</label>
    <input id="search-input" type="search" aria-describedby="search-hint" />
    <span id="search-hint" class="sr-only">Enter at least 2 characters</span>
  </form>
  <section aria-live="polite" aria-atomic="true">
    <!-- Results announced to screen readers -->
  </section>
</main>
```

#### Focus Management

- [ ] Focus trap in modals
- [ ] Return focus after modal close
- [ ] Skip links for main content
- [ ] Logical tab order

---

### Responsive Design

#### Breakpoints (Mobile-First)

| Breakpoint | Width | Layout | Touch Target |
|------------|-------|--------|--------------|
| Mobile | < 768px | Single column, bottom nav | Min 44x44px |
| Tablet | 768-1024px | Two columns, mini sidebar | Min 44x44px |
| Desktop | > 1024px | Full layout, expanded sidebar | Standard |

#### Typography Scale

| Breakpoint | Base Font | Line Height | Heading Scale |
|------------|-----------|-------------|---------------|
| Mobile | 16px | 1.5 | 1.25 (Minor Third) |
| Tablet | 16px | 1.6 | 1.33 (Perfect Fourth) |
| Desktop | 18px | 1.6 | 1.5 (Perfect Fifth) |

---

### Internationalization (i18n)

| Text Key | zh-TW | en-US |
|----------|-------|-------|
| search.placeholder | 搜尋勞動法規 | Search labor laws |
| search.noResults | 找不到結果 | No results found |
| error.network | 網路連線失敗 | Network connection failed |
| pagination.next | 下一頁 | Next |

---

### Analytics Events

| Event Name | Trigger | Properties |
|------------|---------|------------|
| search_performed | User submits search | `{ query, resultCount }` |
| result_clicked | User clicks result | `{ itemId, position }` |
| page_changed | User changes page | `{ fromPage, toPage }` |
| error_occurred | Error displayed | `{ errorType, errorMessage }` |

---

### Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| react | ^18.0 | UI framework |
| @tanstack/react-query | ^5.0 | Data fetching & caching |
| tailwindcss | ^3.0 | Styling |
| react-hook-form | ^7.0 | Form handling |
| zod | ^3.0 | Schema validation |
| dompurify | ^3.0 | XSS sanitization |
| @axe-core/react | ^4.0 | Accessibility testing |
```

## Guidelines

- Be specific about component props and types
- Include all possible UI states (loading, error, empty, success)
- Document keyboard interactions for accessibility
- Specify responsive breakpoints with mobile-first approach
- Include TypeScript interfaces when relevant
- **Always include Performance, Testing, and Security sections**
- Define accessibility requirements with WCAG level
- Include i18n considerations for multi-language support
