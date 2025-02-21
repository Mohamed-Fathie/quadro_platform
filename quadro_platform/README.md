# quadro_platform

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# OffersCubit White Box Testing

## **Test Cases**

| Test ID | Description | Expected States | Coverage |
|---------|-------------|-----------------|----------|
| TC-1    | Initial state | `OfferFetchloading(index: 0)` | State initialization |
| TC-2    | Fetch "All" offers successfully | `OfferFetchloading` → `OfferFetchAllSuccess` | `fetchOffers`, `getIdBasedOnRequestType` |
| TC-3    | Fetch "In Progress" offers | `OfferFetchloading` → `OfferFetchInprogressSuccess` | Status mapping logic |
| TC-4    | Fetch "Pending" offers | `OfferFetchloading` → `OfferFetchPendingSuccess` | Filter branching |
| TC-5    | Fetch "Requests" | `OfferFetchloading` → `RequestSuccess` | `statusMap` reset logic |
| TC-6    | Error handling | `OfferFetchloading` → `OfferFetchFailure` | Exception handling |

---

## **Example Test Code**
### **Test Setup**
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:your_app/offers_cubit.dart';
import 'offers_cubit_test.mocks.dart';

void main() {
  late MockRepositoryManager mockRepo;
  final mockUser = QuadroUser(id: 'user123');
  final mockWorkshop = Workshop(ownerId: 'workshop456');
  final mockMaintenanceRequest = MaintenanceRequestDomainModel();

  setUp(() {
    mockRepo = MockRepositoryManager();
  });
}