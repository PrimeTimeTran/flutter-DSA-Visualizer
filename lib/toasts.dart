import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class Toaster {
  BuildContext context;
  Toaster(this.context);
  void displayCustomMotionToast() {
    MotionToast(
      primaryColor: Colors.pink,
      title: const Text(
        'Bugatti',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      dismissable: false,
      description: const Text(
        'Automobiles Ettore Bugatti was a German then French manufacturer of high-performance automobiles. The company was founded in 1909 in the then-German city of Molsheim, Alsace, by the Italian-born industrial designer Ettore Bugatti. ',
      ),
    ).show(context);
  }

  void displayDeleteMotionToast() {
    MotionToast.delete(
      title: const Text(
        'Deleted',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('The item is deleted'),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
    ).show(context);
  }

  void displayErrorMotionToast() {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Please enter your name'),
      position: MotionToastPosition.top,
      barrierColor: Colors.black.withOpacity(0.3),
      width: 300,
      height: 80,
      dismissable: false,
    ).show(context);
  }

  void displayInfoMotionToast(String body) {
    MotionToast.info(
      title: const Text(
        'Info',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      position: MotionToastPosition.bottom,
      description: Text(body),
    ).show(context);
  }

  void displayMotionToastWithBorder() {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.deepOrange,
      title: const Text('Top Motion Toast'),
      description: const Text('Another motion toast example'),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      displayBorder: true,
      width: 350,
      height: 100,
      margin: const EdgeInsets.only(
        top: 30,
      ),
    ).show(context);
  }

  void displayMotionToastWithoutSideBar() {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.orange[500]!,
      secondaryColor: Colors.grey,
      backgroundType: BackgroundType.solid,
      title: const Text('Two Color Motion Toast'),
      description: const Text('Another motion toast example'),
      displayBorder: true,
      displaySideBar: false,
    ).show(context);
  }

  void displayResponsiveMotionToast() {
    MotionToast(
      icon: Icons.rocket_launch,
      primaryColor: Colors.purple,
      title: const Text(
        'Custom Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text(
        'Hello my name is Flutter dev',
      ),
    ).show(context);
  }

  void displaySimultaneouslyToasts() {
    MotionToast.warning(
      title: const Text(
        'Warning Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('This is a Warning'),
      animationCurve: Curves.bounceIn,
      borderRadius: 0,
      animationDuration: const Duration(milliseconds: 1000),
    ).show(context);
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Please enter your name'),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  void displaySuccessMotionToast() {
    MotionToast toast = MotionToast(
      primaryColor: Colors.red,
      description: const Text(
        'This is a description example',
        style: TextStyle(fontSize: 12),
      ),
      dismissable: true,
      displaySideBar: false,
    );
    toast.show(context);
    // Future.delayed(const Duration(seconds: 4)).then((value) {
    //   toast.closeOverlay();
    // });
  }

  void displayTransparentMotionToast() {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.grey[400]!,
      secondaryColor: Colors.yellow,
      backgroundType: BackgroundType.transparent,
      title: const Text(
        'Two Color Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Another motion toast example'),
      position: MotionToastPosition.center,
      width: 350,
      height: 100,
    ).show(context);
  }

  void displayTwoColorsMotionToast() {
    MotionToast(
      icon: Icons.zoom_out,
      primaryColor: Colors.orange[500]!,
      secondaryColor: Colors.grey,
      backgroundType: BackgroundType.solid,
      title: const Text(
        'Two Color Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('Another motion toast example'),
      position: MotionToastPosition.top,
      animationType: AnimationType.fromTop,
      width: 350,
      height: 100,
    ).show(context);
  }

  void displayWarningMotionToast() {
    MotionToast.warning(
      title: const Text(
        'Warning Motion Toast',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('This is a Warning'),
      animationCurve: Curves.bounceIn,
      borderRadius: 0,
      animationDuration: const Duration(milliseconds: 1000),
    ).show(context);
  }
}

enum ToastType { info }
