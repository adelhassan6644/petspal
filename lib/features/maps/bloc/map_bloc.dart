import 'dart:developer';

import 'package:zurex/app/core/app_core.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../data/error/failures.dart';
import '../models/location_model.dart';
import '../models/prediction_model.dart';
import '../repo/maps_repo.dart';
import 'package:geolocator/geolocator.dart';

class MapBloc extends Bloc<AppEvent, AppState> {
  final MapsRepo repo;

  MapBloc({required this.repo}) : super(Loading()) {
    on<Init>(onInit);
    on<Update>(onUpdate);
  }

  List<PredictionModel> _predictionList = [];
  Position? pickPosition;

  Future<List<PredictionModel>> searchLocation(
      BuildContext context, String text) async {
    if (text.isNotEmpty) {
      Either<ServerFailure, Response> response =
          await repo.searchLocation(text);
      response.fold((error) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: error.error,
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Colors.transparent));
      }, (response) {
        _predictionList = [];
        response.data['predictions'].forEach((prediction) =>
            _predictionList.add(PredictionModel.fromJson(prediction)));
      });
    }
    return _predictionList;
  }

  LocationModel currentLocation = LocationModel();

  Future<void> onInit(Init event, Emitter<AppState> emit) async {
    GoogleMapController? mapController =
        (event.arguments as Map<String, dynamic>?)?["controller"];
    if ((event.arguments as Map<String, dynamic>?)?["lat"] != null) {
      pickPosition = Position(
          latitude: (event.arguments as Map)["lat"],
          longitude: (event.arguments as Map)["long"],
          timestamp: DateTime.now(),
          heading: 1,
          accuracy: 1,
          altitude: 1,
          speedAccuracy: 1,
          speed: 1,
          altitudeAccuracy: 1,
          headingAccuracy: 1);
    } else {
      Position newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      pickPosition = Position(
          latitude: newLocalData.latitude,
          longitude: newLocalData.longitude,
          timestamp: DateTime.now(),
          heading: 1,
          accuracy: 1,
          altitude: 1,
          speedAccuracy: 1,
          speed: 1,
          altitudeAccuracy: 1,
          headingAccuracy: 1);
    }

    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(pickPosition!.latitude, pickPosition!.longitude),
          zoom: 18),
    ));

    currentLocation.address = await formatLatLng(
        latLng: LatLng(pickPosition!.latitude, pickPosition!.longitude));
    currentLocation.latitude = pickPosition!.latitude;
    currentLocation.longitude = pickPosition!.longitude;
    emit(Done(model: currentLocation));
  }

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    CameraPosition position = event.arguments as CameraPosition;
    pickPosition = Position(
        latitude: position.target.latitude,
        longitude: position.target.longitude,
        timestamp: DateTime.now(),
        heading: 1,
        accuracy: 1,
        altitude: 1,
        speedAccuracy: 1,
        speed: 1,
        altitudeAccuracy: 1,
        headingAccuracy: 1);

    currentLocation.address = await formatLatLng(
        latLng: LatLng(pickPosition!.latitude, pickPosition!.longitude));
    currentLocation.latitude = pickPosition!.latitude;
    currentLocation.longitude = pickPosition!.longitude;
    emit(Done(model: currentLocation));
  }

  Future<String> formatLatLng({
    required LatLng latLng,
  }) async {
    log("${latLng.latitude}/${latLng.longitude}");
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placeMarks[0];
    List<String> address = [];
    print(place.toJson());
    try {
      if (place.locality != "") {
        address.add(place.locality!);
      }
      address.add(place.subAdministrativeArea!);
      address.add(place.administrativeArea!);
      return "${place.name} ${address.toSet().join(",")}";
    } on FormatException {
      address.add(place.name ?? "");
      if (place.locality != "") {
        address.add(place.locality!);
      }

      address.add(place.subAdministrativeArea!);
      address.add(place.administrativeArea!);
      return address.toSet().join(",");
    }
  }
}
