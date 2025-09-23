# Simple Responsive Breakpoints - Quick Guide

## Overview
Enhanced your existing `context.responsive()` method with simple breakpoint support. No complex hard-coding needed!

## 3 Simple Breakpoints
- **Mobile**: < 600px (phones)
- **Tablet**: 600px - 1199px (tablets)  
- **Desktop**: 1200px+ (desktop/laptop)

## Usage Patterns

### 1. Enhanced `context.responsive()` - Same method, now with breakpoint options

```dart
// Old way (still works)
fontSize: context.responsive(16),

// New way with breakpoints
fontSize: context.responsive(
  16,           // base value for scaling
  mobile: 14,   // specific value for mobile
  tablet: 18,   // specific value for tablet  
  desktop: 22,  // specific value for desktop
),
```

### 2. `context.responsiveBreakpoint()` - For any type of value

```dart
// Different values per screen size
color: context.responsiveBreakpoint(
  mobile: Colors.blue,
  tablet: Colors.green,
  desktop: Colors.purple,
),

crossAxisCount: context.responsiveBreakpoint(
  mobile: 1,
  tablet: 2, 
  desktop: 3,
),

text: context.responsiveBreakpoint(
  mobile: 'Mobile',
  tablet: 'Tablet',
  desktop: 'Desktop',
),
```

### 3. Boolean Helpers - For conditional layouts

```dart
// Check screen type
if (context.isMobile) {
  return MobileLayout();
} else if (context.isTabletSize) {
  return TabletLayout();  
} else {
  return DesktopLayout();
}

// Show/hide based on screen size
if (context.isTabletOrDesktop) {
  return Sidebar();
}
```

## Real Examples

### Responsive Padding
```dart
Container(
  padding: EdgeInsets.all(
    context.responsive(16, mobile: 12, tablet: 16, desktop: 24),
  ),
  child: content,
)
```

### Responsive Font Sizes
```dart
Text(
  'Hello World',
  style: TextStyle(
    fontSize: context.responsive(18, mobile: 16, tablet: 20, desktop: 24),
  ),
)
```

### Responsive Grid
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.responsiveBreakpoint(
      mobile: 1,
      tablet: 2,
      desktop: 3,
    ),
  ),
  // ...
)
```

### Responsive Layout
```dart
Widget build(BuildContext context) {
  return context.responsiveBreakpoint(
    mobile: _buildMobileLayout(),
    tablet: _buildTabletLayout(), 
    desktop: _buildDesktopLayout(),
  );
}
```

## Migration from Your Current Code

Your existing `context.responsive()` calls work exactly the same:

```dart
// This still works perfectly
width: context.responsive(200),
height: context.responsiveHeight(100),
padding: EdgeInsets.all(context.responsive(16)),
```

Just add breakpoint parameters when you need different values:

```dart
// Enhanced version
width: context.responsive(200, mobile: 150, desktop: 250),
padding: EdgeInsets.all(
  context.responsive(16, mobile: 12, tablet: 16, desktop: 20),
),
```

## Key Benefits

✅ **No breaking changes** - All your existing code works  
✅ **Simple** - Only 3 breakpoints (mobile/tablet/desktop)  
✅ **Flexible** - Use breakpoints only when needed  
✅ **Clean** - No hard-coded values scattered in widgets  
✅ **Type-safe** - Works with any data type  

## Quick Reference

```dart
// Enhanced responsive method
context.responsive(value, mobile: mobileValue, tablet: tabletValue, desktop: desktopValue)

// Breakpoint method for any type
context.responsiveBreakpoint(mobile: value1, tablet: value2, desktop: value3)

// Screen type checks
context.isMobile           // < 600px
context.isTabletSize       // 600px - 1199px  
context.isDesktop          // 1200px+
context.isTabletOrDesktop  // 600px+
```

Start using breakpoints gradually - your existing `context.responsive()` calls continue to work perfectly!