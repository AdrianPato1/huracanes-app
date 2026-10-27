import 'package:alerta_cancun_app/presentation/screens/refugios/refugio_detalle_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('buildRefugioMapUri usa OpenStreetMap con coordenadas del refugio', () {
    final uri = buildRefugioMapUri(
      latitude: 21.1619,
      longitude: -86.8252,
    );

    expect(uri.scheme, 'https');
    expect(uri.host, 'www.openstreetmap.org');
    expect(uri.queryParameters['mlat'], '21.1619');
    expect(uri.queryParameters['mlon'], '-86.8252');
    expect(uri.fragment, 'map=16/21.1619/-86.8252');
  });
}
