import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const baseUrl = 'http://localhost:8000'; // Assume test server is running on this port

  // Mock tokens for testing
  const fakeToken = 'fake_token';
  const fakeSpotifyToken = 'fake_spotify_token';
  const fakeYtmusicToken = 'fake_ytmusic_token';
  const fakeMalToken = 'fake_mal_token';

  group('Buds API Tests', () {
    test('get bud profile', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/profile'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('get buds by top artists', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/top/artists'));
      expect(response.statusCode, 200);
    });

    test('get buds by top tracks', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/top/tracks'));
      expect(response.statusCode, 200);
    });

    test('get buds by top genres', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/top/genres'));
      expect(response.statusCode, 200);
    });

    test('get buds by top anime', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/top/anime'));
      expect(response.statusCode, 200);
    });

    test('get buds by top manga', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/top/manga'));
      expect(response.statusCode, 200);
    });

    test('get buds by liked artists', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/liked/artists'));
      expect(response.statusCode, 200);
    });

    test('get buds by liked tracks', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/liked/tracks'));
      expect(response.statusCode, 200);
    });

    test('get buds by liked genres', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/liked/genres'));
      expect(response.statusCode, 200);
    });

    test('get buds by liked albums', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/liked/albums'));
      expect(response.statusCode, 200);
    });

    test('get buds by liked aio', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/liked/aio'));
      expect(response.statusCode, 200);
    });

    test('get buds by played tracks', () async {
      final response = await http.post(Uri.parse('$baseUrl/bud/played/tracks'));
      expect(response.statusCode, 200);
    });

    test('get buds by track', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/track'),
        body: {'track_id': '3ca5bebc7e4c4b208f24a771bbcde4d5'},
      );
      expect(response.statusCode, 200);
    });

    test('get buds by artist', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/artist'),
        body: {'artist_id': 'ffc25621d22e4c4c8ca3617f65d74abb'},
      );
      expect(response.statusCode, 200);
    });

    test('get buds by genre', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/genre'),
        body: {'genre_id': '0b8ce6a044334131948a5ea3532a0021'},
      );
      expect(response.statusCode, 200);
    });
  });

  group('Auth API Tests', () {
    test('spotify connect', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/spotify/connect'),
        body: {'token': fakeToken, 'spotify_token': fakeSpotifyToken},
      );
      expect(response.statusCode, 200);
    });

    test('ytmusic connect', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/ytmusic/connect'),
        body: {'token': fakeToken, 'ytmusic_token': fakeYtmusicToken},
      );
      expect(response.statusCode, 200);
    });

    test('lastfm connect', () async {
      final response = await http.post(Uri.parse('$baseUrl/lastfm/connect'));
      expect(response.statusCode, 200);
    });

    test('mal connect', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/mal/connect'),
        body: {'mal_token': fakeMalToken},
      );
      expect(response.statusCode, 200);
    });

    test('login', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: {'username': 'fake_user', 'password': 'password'},
      );
      expect(response.statusCode, 200);
    });

    test('register', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {
          'email': 'mnagy3003@gmail.com',
          'username': 'crazydiamond',
          'password': 'password',
          'confirm_password': 'password'
        },
      );
      expect(response.statusCode, 200);
    });

    test('service login', () async {
      final response = await http.get(
        Uri.parse('$baseUrl/service/login?service=spotify'),
      );
      expect(response.statusCode, 200);
    });

    test('spotify refresh-token', () async {
      final response = await http.post(Uri.parse('$baseUrl/spotify/token/refresh'));
      expect(response.statusCode, 200);
    });
  });

  group('Common API Tests', () {
    test('top artists', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/top/artists'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });

    test('top tracks', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/top/tracks'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });

    test('top genres', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/top/genres'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });

    test('top anime', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/top/anime'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('top manga', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/top/manga'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('liked artists', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/liked/artists'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });

    test('liked tracks', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/liked/tracks'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });

    test('liked genres', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/liked/genres'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });

    test('liked albums', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/liked/albums'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('played tracks', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/bud/common/played/tracks'),
        body: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e'},
      );
      expect(response.statusCode, 200);
    });
  });

  group('Me API Tests', () {
    test('get profile', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/profile'),
        body: {'service': 'spotify', 'token': fakeToken},
      );
      expect(response.statusCode, 200);
    });

    test('set profile', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/profile/set'),
        body: {
          'service': 'spotify',
          'token': fakeToken,
          'bio': '"cool bio"',
          'display_name': '"mahmoud khashaba"'
        },
      );
      expect(response.statusCode, 200);
    });

    test('update my likes', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/likes/update'),
        body: {'service': 'spotify', 'spotify_token': fakeSpotifyToken},
      );
      expect(response.statusCode, 200);
    });

    test('top artists', () async {
      final response = await http.post(Uri.parse('$baseUrl/me/top/artists'));
      expect(response.statusCode, 200);
    });

    test('top tracks', () async {
      final response = await http.post(Uri.parse('$baseUrl/me/top/tracks'));
      expect(response.statusCode, 200);
    });

    test('top genres', () async {
      final response = await http.post(Uri.parse('$baseUrl/me/top/genres'));
      expect(response.statusCode, 200);
    });

    test('top anime', () async {
      final response = await http.post(Uri.parse('$baseUrl/me/top/anime'));
      expect(response.statusCode, 200);
    });

    test('top manga', () async {
      final response = await http.post(Uri.parse('$baseUrl/me/top/manga'));
      expect(response.statusCode, 200);
    });

    test('liked artists', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/liked/artists'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('liked tracks', () async {
      final response = await http.post(Uri.parse('$baseUrl/me/liked/tracks'));
      expect(response.statusCode, 200);
    });

    test('liked genres', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/liked/genres'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('liked albums', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/liked/albums'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });

    test('played tracks', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/me/played/tracks'),
        body: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'},
      );
      expect(response.statusCode, 200);
    });
  });

  group('Other API Tests', () {
    test('spotify create user seed', () async {
      final response = await http.get(Uri.parse('$baseUrl/spotify/seed/user/create'));
      expect(response.statusCode, 200);
    });

    test('merge similars', () async {
      final response = await http.get(Uri.parse('$baseUrl/merge-similars'));
      expect(response.statusCode, 200);
    });

    test('health', () async {
      final response = await http.post(Uri.parse('$baseUrl/health'));
      expect(response.statusCode, 200);
    });
  });
}