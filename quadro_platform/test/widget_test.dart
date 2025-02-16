import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quadro_platform/features/user/repository/user_repository.dart';
import 'package:quadro_platform/features/workshop_authentication/models/workshop_user.dart';
import 'package:quadro_platform/features/workshop_authentication/repository/storage_repository.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/maintenance_requests_repo.dart';
import 'package:quadro_platform/features/workshop_main_screen/repository/models/maintenance_request.dart';
import 'package:quadro_platform/shared/enum/car_brands.dart';
import 'package:quadro_platform/shared/enum/car_models.dart';
import 'package:quadro_platform/user/view/maintenance_request/cubit/maintenacne_request_cubit.dart';
// Import your cubit, state, and model classes.

// -------------------------
// Mocks for dependencies
// -------------------------

// -------------------------
// Mocks for dependencies
// -------------------------
class MockMaintenanceRequestsRepository extends Mock
    implements MaintenanceRequestsRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockStorageRepository extends Mock implements StorageRepository {}

class FakeXFile extends Fake implements XFile {}

class FakeMaintenanceRequest extends Fake implements MaintenanceRequest {}

// -------------------------
// Dummy values for tests using enums
// -------------------------
const dummyBrand = CarBrand.Toyota;
const dummyModel = CarModels.toyotaCorolla;
final dummyWorkshop = Workshop(
  ownerId: 'workshop123',
  street: '',
  imagePath: '',
  city: '',
  name: '',
  description: '',
  phone: '',
  status: [],
  carBrands: [],
  coordination: null,
);
const dummyDescription = 'Test description';
final dummyFile = File('test/dummy.png');
const dummyUrl = 'http://example.com/image.png';

void main() async {
  late MaintenanceRequestCubit cubit;
  late MockMaintenanceRequestsRepository mockMaintenanceRequestsRepository;
  late MockUserRepository mockUserRepository;
  late MockStorageRepository mockStorageRepository;
  setUpAll(() {
    // Register fallback values for custom types
    registerFallbackValue(FakeXFile());
    registerFallbackValue(FakeMaintenanceRequest());
  });
  setUp(() {
    // Initialize mocks.
    mockMaintenanceRequestsRepository = MockMaintenanceRequestsRepository();
    mockUserRepository = MockUserRepository();
    mockStorageRepository = MockStorageRepository();
// Register fallback values for custom types
    registerFallbackValue(FakeXFile());
    registerFallbackValue(FakeMaintenanceRequest());
    // When getuserId is called on the user repository, return a dummy user id.
    when(() => mockUserRepository.getuserId).thenReturn('user123');

    // Instantiate the cubit with mocked repositories.
    cubit = MaintenanceRequestCubit(
      mockMaintenanceRequestsRepository,
      mockUserRepository,
      mockStorageRepository,
    );

    // Override the StorageRepository instance with our mock.
  });

  tearDown(() {
    cubit.close();
  });

  group('selectCarBrand', () {
    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits a state with selectedCarBrand set and selectedCarModel reset to null',
      build: () => cubit,
      act: (cubit) => cubit.selectCarBrand(dummyBrand),
      expect: () => [
        cubit.state.copyWith(
          selectedCarBrand: dummyBrand,
          selectedCarModel: null,
        ),
      ],
    );
  });

  group('selectCarModel', () {
    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits a state with selectedCarModel set when a brand is already selected',
      build: () {
        // Set an initial state with a brand selected.
        cubit.emit(cubit.state.copyWith(selectedCarBrand: dummyBrand));
        return cubit;
      },
      act: (cubit) => cubit.selectCarModel(dummyModel),
      expect: () => [
        cubit.state.copyWith(selectedCarModel: dummyModel),
      ],
    );

    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits a state with selectedCarModel set even if no brand is selected',
      build: () => cubit,
      act: (cubit) => cubit.selectCarModel(dummyModel),
      expect: () => [
        cubit.state.copyWith(selectedCarModel: dummyModel),
      ],
    );
  });

  group('updateDescription', () {
    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits a state with updated description when input is valid (<=350 characters)',
      build: () => cubit,
      act: (cubit) => cubit.updateDescription(dummyDescription),
      expect: () => [
        cubit.state.copyWith(
          description: dummyDescription,
          status: MaintenanceRequestCubitStatues.initial,
        ),
      ],
    );

    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'does not emit a new state when the description exceeds 350 characters',
      build: () => cubit,
      act: (cubit) {
        final longDescription = 'a' * 351;
        cubit.updateDescription(longDescription);
      },
      expect: () => [],
    );
  });

  group('updateImage', () {
    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits a state with the updated image',
      build: () => cubit,
      act: (cubit) => cubit.updateImage(dummyFile),
      expect: () => [
        cubit.state.copyWith(image: dummyFile),
      ],
    );
  });

  group('submitRequest', () {
    const dummyBrand = CarBrand.Toyota;
    const dummyModel = CarModels.toyotaCorolla;
    final dummyWorkshop = Workshop(
      ownerId: 'workshop123',
      street: '',
      imagePath: '',
      city: '',
      name: '',
      description: '',
      phone: '',
      status: [],
      carBrands: [],
      coordination: null,
    );
    final imageFile = File('path/to/image.jpg');

    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits [submitting, success] when submission is successful',
      build: () {
        when(() => mockUserRepository.getuserId).thenReturn('user1');
        when(() => mockStorageRepository.uploadImageWithProgress(
              path: any(named: 'path'),
              xFile: any(named: 'xFile'),
              file: any(named: 'file'),
              onProgressUpdate: any(named: 'onProgressUpdate'),
            )).thenAnswer((_) async => 'image_url');
        when(() =>
                mockMaintenanceRequestsRepository.addMaintenanceRequest(any()))
            .thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) async {
        cubit.selectCarBrand(dummyBrand);
        cubit.selectCarModel(dummyModel);
        cubit.updateDescription('Test description');
        cubit.updateImage(imageFile);
        await cubit.submitRequest(dummyWorkshop);
      },
      expect: () => [
        cubit.state.copyWith(
          status: MaintenanceRequestCubitStatues.submitting,
        ),
        cubit.state.copyWith(
          status: MaintenanceRequestCubitStatues.success,
        ),
      ],
    );

    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'emits [submitting, failure] when submission fails',
      build: () {
        when(() => mockUserRepository.getuserId).thenReturn('user1');
        when(() => mockStorageRepository.uploadImageWithProgress(
              path: any(named: 'path'),
              xFile: any(named: 'xFile'),
              file: any(named: 'file'),
              onProgressUpdate: any(named: 'onProgressUpdate'),
            )).thenAnswer((_) async => 'image_url'); // <-- Correct chaining
        when(() =>
                mockMaintenanceRequestsRepository.addMaintenanceRequest(any()))
            .thenThrow(Exception('Submission failed'));
        return cubit;
      },
      act: (cubit) async {
        cubit.selectCarBrand(dummyBrand);
        cubit.selectCarModel(dummyModel);
        cubit.updateDescription('Test description');
        cubit.updateImage(imageFile);
        await cubit.submitRequest(dummyWorkshop);
      },
      expect: () => [
        cubit.state.copyWith(
          status: MaintenanceRequestCubitStatues.submitting,
        ),
        cubit.state.copyWith(
          status: MaintenanceRequestCubitStatues.failure,
          errorMessage: 'Exception: Submission failed',
        ),
      ],
    );

    blocTest<MaintenanceRequestCubit, MaintenanceRequestState>(
      'does not emit any state when required fields are missing',
      build: () => cubit,
      act: (cubit) async => cubit.submitRequest(dummyWorkshop),
      expect: () => [],
    );
  });
}
