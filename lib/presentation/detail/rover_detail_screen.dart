import 'package:flutter/material.dart';

import '../../domain/models/mars_photo.dart';
import '../../domain/models/mars_rover.dart';
import '../../domain/usecases/get_mars_photos.dart';
import '../common/date_format.dart';
import '../common/error_message.dart';
import '../common/load_state.dart';
import '../common/widgets/nasa_app_bar.dart';
import '../common/widgets/status_content.dart';
import 'rover_detail_controller.dart';
import 'rover_detail_state.dart';
import 'widgets/photo_tile.dart';

class RoverDetailScreen extends StatefulWidget {
  const RoverDetailScreen({
    super.key,
    required this.rover,
    required this.getPhotos,
  });

  final MarsRover rover;
  final GetMarsPhotos getPhotos;

  @override
  State<RoverDetailScreen> createState() => _RoverDetailScreenState();
}

class _RoverDetailScreenState extends State<RoverDetailScreen> {
  late final _controller = RoverDetailController(
    roverId: widget.rover.id,
    getPhotos: widget.getPhotos,
  );
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadNearBottom);
    _controller.retry();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _loadNearBottom() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 600 &&
        _controller.state.paginationError == null) {
      _controller.loadMore();
    }
  }

  Future<void> _selectDate() async {
    final selectedDate = DateTime.parse(_controller.state.selectedDate);
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.parse(widget.rover.landingDate),
      lastDate: today,
      helpText: 'Select Date',
    );
    if (!mounted ||
        picked == null ||
        apiDate(picked) == _controller.state.selectedDate) {
      return;
    }
    _scrollController.jumpTo(0);
    _controller.loadDate(apiDate(picked));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const NasaAppBar(),
    body: SafeArea(
      top: false,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final state = _controller.state;
          if (state.photos is Success<List<MarsPhoto>> &&
              state.hasMore &&
              !state.isLoadingMore &&
              state.paginationError == null) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _loadNearBottom(),
            );
          }
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverToBoxAdapter(child: _header(state)),
              ),
              ..._photoContent(state),
              if (state.isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (state.paginationError case final error?)
                SliverToBoxAdapter(
                  child: StatusContent(
                    title: 'Unable to load more photos',
                    message: errorMessage(error),
                    onRetry: _controller.loadMore,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
    ),
  );

  Widget _header(RoverDetailState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(widget.rover.name, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fact('Launch', displayDate(widget.rover.launchDate)),
                const SizedBox(height: 4),
                _fact('Landing', displayDate(widget.rover.landingDate)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fact('Total Photos', '${widget.rover.totalPhotos}'),
                const SizedBox(height: 4),
                _fact('Cameras Available', '${widget.rover.cameras.length}'),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Semantics(
        button: true,
        label: 'Select Date',
        child: InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Date',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.date_range_outlined),
            ),
            child: Text(displayDate(state.selectedDate)),
          ),
        ),
      ),
    ],
  );

  Widget _fact(String label, String value) => Text(
    '$label: $value',
    style: Theme.of(context).textTheme.bodySmall
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
  );

  List<Widget> _photoContent(RoverDetailState state) => switch (state.photos) {
    Loading() => [
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    ],
    Empty() => [
      const SliverToBoxAdapter(
        child: StatusContent(
          title: 'No photos taken on this day',
          message: 'Try picking a different date.',
        ),
      ),
    ],
    Failure(:final error) => [
      SliverToBoxAdapter(
        child: StatusContent(
          title: 'Unable to load photos',
          message: errorMessage(error),
          onRetry: _controller.retry,
        ),
      ),
    ],
    Success(:final value) => [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: value.length,
          itemBuilder: (_, index) =>
              PhotoTile(key: ValueKey(value[index].id), photo: value[index]),
        ),
      ),
    ],
  };
}
