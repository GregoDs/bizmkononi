import 'package:biz_mkononi/features/employees/salaries/ui/add_salary.dart';
import 'package:biz_mkononi/features/employees/ui/add_employee.dart';
import 'package:biz_mkononi/features/finance/income/ui/add_income.dart';
import 'package:biz_mkononi/features/home/ui/landing.dart';

import '../../exports.dart';
import '../../features/auth/ui/forgot_password.dart';
import '../../features/auth/ui/resend_verification.dart';
import '../../features/auth/ui/reset_password.dart';
import '../../features/auth/ui/verify.dart';
import '../../features/businesses/ui/add_business.dart';
import '../../features/businesses/ui/business_landing.dart';
import '../../features/categories/ui/add_category.dart';
import '../../features/customers/ui/add_customer.dart';
import '../../features/finance/expenses/ui/add_expense.dart';
import '../../features/insights/ui/overall_insight.dart';
import '../../features/onboarding/splash.dart';
import '../../features/products/ui/add_product.dart';
import '../../features/sales/ui/add_sale.dart';
import '../../features/suppliers/ui/add_supplier.dart';
import '../../features/supplies/ui/add_supply.dart';

class AppRoutes {
  static final routes = {
    Routes.splash: (context) => const SplashScreen(),
    Routes.signUp: (context) => const SignUp(),
    Routes.signIn: (context) => const SignIn(),
    Routes.landingScreen: (context) => const LandingPage(),
    Routes.addBusiness: (context) => const AddBusiness(),
    Routes.overallInsight: (context) => const OverallInsight(),
    Routes.businessLandingPage: (context) => const BusinessLandingPage(),
    Routes.addCustomer: (context) => const AddCustomer(),
    Routes.addProduct: (context) => const AddProduct(),
    Routes.addCategory: (context) => const AddCategory(),
    Routes.addSupply: (context) => const AddSupply(),
    Routes.addSupplier: (context) => const AddSupplier(),
    Routes.addSale: (context) => const AddSale(),
    Routes.addEmployee: (context) => const AddEmployee(),
    Routes.addSalary: (context) => const AddSalary(),
    Routes.addExpense: (context) => const AddExpense(),
    Routes.addIncome: (context) => const AddIncome(),
    Routes.onBoarding: (context) => const OnBoarding(),
    Routes.resendVerification: (context) => const ResendVerification(),
    Routes.verify: (context) => const Verify(phoneNumber: '',),
    Routes.forgotPassword: (context) => const ForgotPassword(),
    Routes.resetPassword: (context) => const ResetPassword(),
  };
}
