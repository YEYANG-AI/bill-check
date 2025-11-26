class ApiPath {
  static const baseUrl = 'http://192.168.1.3:3000/api';
  // static const baseUrl = 'http://10.216.7.204:3000/api';
  static const login = '$baseUrl/auth/login';
  static const banner = '$baseUrl/banners';
  static const customer = '$baseUrl/customers';
  static const updateCustomer = '$baseUrl/customers/{id}';
  static const clothes = '$baseUrl/clothes';
  static const washingMachines = '$baseUrl/washing-machines';
  static const updateProfile = '$baseUrl/users/update-profile'; //put
  static const changePassword = '$baseUrl/users/change-password'; //put
  static const getProfile = '$baseUrl/users/profile'; //put
  static const uploadImage = '$baseUrl/image/upload-single-file'; //post
}
