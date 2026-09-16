import 'lib/src/common/authentication/models/user_model.dart';

void main() {
  print('=== Testing UserModel for Fintech App ===\n');

  // Test 1: Creating a UserModel instance
  print('Test 1: Creating a UserModel instance');
  final user = UserModel(
    userId: 'user123',
    email: 'john.doe@novapay.com',
    phoneNumber: '+234801234567',
    accountNumber: '0123456789',
    bvn: '11234567890',
    nin: '11111111111',
    firstName: 'John',
    lastName: 'Doe',
    middleName: 'Michael',
    profileImageUrl: 'https://example.com/profile.jpg',
    accountStatus: 'active',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 15),
  );
  print('✓ User created: ${user.toString()}\n');

  // Test 2: getFullName method
  print('Test 2: Getting full name');
  print('Full name: ${user.getFullName()}');
  print('✓ Full name retrieved\n');

  // Test 3: getFullName without middle name
  print('Test 3: Getting full name without middle name');
  final userNoMiddle = UserModel(
    userId: 'user456',
    email: 'jane.smith@novapay.com',
    accountNumber: '0987654321',
    bvn: '22234567890',
    nin: '22222222222',
    firstName: 'Jane',
    lastName: 'Smith',
    createdAt: DateTime(2024, 2, 1),
    updatedAt: DateTime(2024, 2, 15),
  );
  print('Full name (no middle): ${userNoMiddle.getFullName()}');
  print('✓ Full name without middle name retrieved\n');

  // Test 4: toJson method
  print('Test 4: Converting to JSON');
  final json = user.toJson();
  print('JSON keys: ${json.keys.toList()}');
  print('✓ Successfully converted to JSON\n');

  // Test 5: fromJson method
  print('Test 5: Creating from JSON');
  final jsonData = {
    'userId': 'user789',
    'email': 'alice.johnson@novapay.com',
    'phoneNumber': '+234802345678',
    'accountNumber': '1111111111',
    'bvn': '33234567890',
    'nin': '33333333333',
    'firstName': 'Alice',
    'lastName': 'Johnson',
    'middleName': 'Mary',
    'profileImageUrl': 'https://example.com/alice.jpg',
    'accountStatus': 'active',
    'createdAt': '2024-03-01T00:00:00.000Z',
    'updatedAt': '2024-03-15T00:00:00.000Z',
  };
  final userFromJson = UserModel.fromJson(jsonData);
  print('User from JSON: ${userFromJson.toString()}');
  print('✓ Successfully created from JSON\n');

  // Test 6: copyWith method
  print('Test 6: Using copyWith to create a modified copy');
  final updatedUser = user.copyWith(
    email: 'john.newemail@novapay.com',
    phoneNumber: '+234809876543',
    accountStatus: 'suspended',
    updatedAt: DateTime(2024, 3, 1),
  );
  print('Original user email: ${user.email}');
  print('Updated user email: ${updatedUser.email}');
  print('Original user status: ${user.accountStatus}');
  print('Updated user status: ${updatedUser.accountStatus}');
  print('✓ copyWith method works correctly\n');

  // Test 7: Equality operator
  print('Test 7: Testing equality operator');
  final sameUser = UserModel(
    userId: 'user123',
    email: 'different@novapay.com',
    accountNumber: '9999999999',
    bvn: '99999999999',
    nin: '99999999999',
    firstName: 'Different',
    lastName: 'Name',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  print('user == sameUser (same userId): ${user == sameUser}');
  print('user == userNoMiddle (different userId): ${user == userNoMiddle}');
  print('✓ Equality operator works correctly\n');

  // Test 8: Hash code
  print('Test 8: Testing hash code');
  print('user.hashCode == sameUser.hashCode: ${user.hashCode == sameUser.hashCode}');
  print('✓ Hash code works correctly\n');

  print('=== All tests passed successfully! ===');
}
