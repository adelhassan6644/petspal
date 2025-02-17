import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/features/maps/models/location_model.dart';
import 'package:petspal/features/maps/repo/maps_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_strings.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_app_bar.dart';
import '../../../data/config/di.dart';
import '../widget/address_result_widget.dart';
import '../bloc/map_bloc.dart';

class PickMapPage extends StatefulWidget {
  const PickMapPage({required this.data, super.key});
  final LocationModel data;

  @override
  State<PickMapPage> createState() => _PickMapPageState();
}

class _PickMapPageState extends State<PickMapPage> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("pick_location")),
      body: SafeArea(
          child: BlocProvider(
        create: (context) => MapBloc(repo: sl<MapsRepo>()),
        child: BlocBuilder<MapBloc, AppState>(
          builder: (context, state) {
            return Stack(
              children: [
                Stack(alignment: Alignment.center, children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      bearing: 192,
                      target: LatLng(
                        widget.data.latitude ?? AppStrings.defaultLat,
                        widget.data.longitude ?? AppStrings.defaultLong,
                      ),
                      zoom: 14,
                    ),
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 100),
                    myLocationButtonEnabled: false,
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (context.read<MapBloc>().currentLocation.longitude ==
                            null) {
                          context.read<MapBloc>().add(Init(
                                arguments: {
                                  "controller": _mapController,
                                },
                              ));
                        } else {
                          context.read<MapBloc>().add(Init(
                                arguments: {
                                  "controller": _mapController,
                                  "lat": widget.data.latitude,
                                  "long": widget.data.longitude,
                                },
                              ));
                        }
                      });
                    },
                    scrollGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onCameraMove: (CameraPosition cameraPosition) {
                      _cameraPosition = cameraPosition;
                    },
                    onCameraIdle: () {
                      if (_cameraPosition != null) {
                        context
                            .read<MapBloc>()
                            .add(Update(arguments: _cameraPosition));
                      }
                    },
                  ),
                  Center(
                      child: state is! Loading
                          ? const Icon(
                              Icons.location_on_rounded,
                              size: 50,
                              color: Styles.PRIMARY_COLOR,
                            )
                          : const CupertinoActivityIndicator()),
                ]),
                AddressResultWidget(onChange: widget.data.onChange),
                Positioned(
                    top: Dimensions.PADDING_SIZE_DEFAULT.h,
                    right: Dimensions.PADDING_SIZE_DEFAULT.w,
                    child: FloatingActionButton.small(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        context.read<MapBloc>().add(Init(
                              arguments: {
                                "controller": _mapController,
                              },
                            ));
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Styles.PRIMARY_COLOR,
                      ),
                    )),
              ],
            );
          },
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
