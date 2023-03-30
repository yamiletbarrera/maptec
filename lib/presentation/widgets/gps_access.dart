import 'package:flutter/material.dart';
import 'package:maptec/blocs/gps_bloc.dart';
import 'package:provider/provider.dart';

class GPSAccess extends StatelessWidget {
  const GPSAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final gpsState = Provider.of<GPSBloc>(context);
    return gpsState.isGPSEnabled ? const _AccessGPS() : const _EnableGPS();
  }
}

class _AccessGPS extends StatelessWidget {
  const _AccessGPS({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.gps_fixed,
          color: themeScheme.secondary,
          size: 120,
        ),
        const SizedBox(
          height: 8,
          width: double.infinity,
        ),
        Text(
          textAlign: TextAlign.center,
          "Es necesario el acceso al GPS y las notificaciones",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: themeScheme.onBackground,
              ),
        ),
        MaterialButton(
          onPressed: () {
            final gpsState = Provider.of<GPSBloc>(context, listen: false);
            gpsState.askGPSAccess();
          },
          elevation: 0,
          color: themeScheme.secondary,
          child: Text(
            "Solicitar acceso",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: themeScheme.onSecondary,
                ),
          ),
        )
      ],
    );
  }
}

class _EnableGPS extends StatelessWidget {
  const _EnableGPS({super.key});

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.gps_off,
          color: themeScheme.error,
          size: 120,
        ),
        const SizedBox(
          height: 8,
          width: double.infinity,
        ),
        Text(
          "Activa el GPS para continuar",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: themeScheme.error,
              ),
        ),
      ],
    );
  }
}
