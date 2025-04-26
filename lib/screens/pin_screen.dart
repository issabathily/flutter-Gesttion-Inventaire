import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retail_app/providers/auth_provider.dart';
import 'package:retail_app/screens/home_screen.dart';
import 'package:retail_app/utils/constants.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final List<String> _pin = ['', '', '', '', '', ''];
  int _currentPinIndex = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  void _addDigit(String digit) {
    if (_currentPinIndex < 6) {
      setState(() {
        _pin[_currentPinIndex] = digit;
        _currentPinIndex++;
        _errorMessage = '';
      });

      // Check if PIN is complete
      if (_currentPinIndex == 6) {
        _verifyPin();
      }
    }
  }

  void _removeDigit() {
    if (_currentPinIndex > 0) {
      setState(() {
        _currentPinIndex--;
        _pin[_currentPinIndex] = '';
        _errorMessage = '';
      });
    }
  }

  Future<void> _verifyPin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final String enteredPin = _pin.join();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyPin(enteredPin);

      if (success) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Code PIN incorrect';
          _pin.fillRange(0, 6, '');
          _currentPinIndex = 0;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur s\'est produite. Veuillez réessayer.';
        _pin.fillRange(0, 6, '');
        _currentPinIndex = 0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildKeypad() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          SizedBox(height: 20),
          // Row 2: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          SizedBox(height: 20),
          // Row 3: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          SizedBox(height: 20),
          // Row 4: empty, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: 60, height: 60), // Empty space
              _buildKeypadButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return InkWell(
      onTap: _isLoading ? null : () => _addDigit(digit),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            digit,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: _isLoading ? null : _removeDigit,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Center(
          child: Icon(Icons.backspace_outlined),
        ),
      ),
    );
  }

  Widget _buildPinIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pin[index].isNotEmpty
                ? AppColors.primary
                : Colors.grey[300],
            border: Border.all(
              color: _pin[index].isNotEmpty
                  ? AppColors.primary
                  : Colors.grey[400]!,
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.username ?? 'Utilisateur';

    return Scaffold(
      appBar: AppBar(
        title: Text('Veiller entre votre mot de passe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Weirel Stock',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Mot de passe Oublier',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
              SizedBox(height: 50),
              _buildPinIndicator(),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              if (_isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              SizedBox(height: 50),
              _buildKeypad(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
