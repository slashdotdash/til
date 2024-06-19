# Capture "Escape" keypress

```typescript
function captureEscapeKeypress(event: Event) {
  const keyboardEvent = event as KeyboardEvent;

  if (keyboardEvent && keyboardEvent.key == 'Escape') {
    event.preventDefault();
    return false;
  }
}
```

```typescript
element.addEventListener('keydown', captureEscapeKeypress);
element.removeEventListener('keydown', captureEscapeKeypress);
```