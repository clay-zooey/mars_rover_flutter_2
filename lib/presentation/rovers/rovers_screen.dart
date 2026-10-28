import 'package:flutter/material.dart';

import '../../domain/models/mars_rover.dart';
import '../../domain/usecases/get_mars_photos.dart';
import '../../domain/usecases/get_mars_rovers.dart';
import '../common/error_message.dart';
import '../common/load_state.dart';
import '../common/widgets/nasa_app_bar.dart';
import '../common/widgets/status_content.dart';
import '../detail/rover_detail_screen.dart';
import 'rovers_controller.dart';
import 'widgets/rover_card.dart';

class RoversScreen extends StatefulWidget {
  const RoversScreen({
    super.key,
    required this.getRovers,
    required this.getPhotos,
  });

  final GetMarsRovers getRovers;
  final GetMarsPhotos getPhotos;

  @override
  State<RoversScreen> createState() => _RoversScreenState();
}

class _RoversScreenState extends State<RoversScreen> {
  late final _controller = RoversController(widget.getRovers);

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openRover(MarsRover rover) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            RoverDetailScreen(rover: rover, getPhotos: widget.getPhotos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const NasaAppBar(),
    body: SafeArea(
      top: false,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => switch (_controller.state) {
          Loading() => const Center(child: CircularProgressIndicator()),
          Empty() => _message(
            'No rovers found',
            'Mars Vista did not return any rover records.',
          ),
          Failure(:final error) => _message(
            'Unable to load rovers',
            errorMessage(error),
          ),
          Success(:final value) => _roverList(value),
        },
      ),
    ),
  );

  Widget _message(String title, String message) => LayoutBuilder(
    builder: (_, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: StatusContent(
            title: title,
            message: message,
            onRetry: _controller.load,
          ),
        ),
      ),
    ),
  );

  Widget _roverList(List<MarsRover> rovers) {
    final columns = MediaQuery.orientationOf(context) == Orientation.landscape
        ? 2
        : 1;
    final rows = (rovers.length / columns).ceil();
    return CustomScrollView(
      key: const PageStorageKey('rover-list'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NASA Mars Rovers',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text('Browse images from NASA Mars Rovers'),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          sliver: SliverList.separated(
            itemCount: rows,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, row) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var column = 0; column < columns; column++) ...[
                  if (column > 0) const SizedBox(width: 12),
                  Expanded(
                    child: row * columns + column >= rovers.length
                        ? const SizedBox.shrink()
                        : RoverCard(
                            rover: rovers[row * columns + column],
                            onViewImages: () =>
                                _openRover(rovers[row * columns + column]),
                          ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
