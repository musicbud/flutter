import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/data/network/dio_client.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';
import 'package:musicbud_flutter/core/network/network_info.dart';
import 'package:musicbud_flutter/models/bud_profile.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/bud_match.dart';

// Generate mocks
@GenerateMocks([
  Dio,
  DioClient,
  TokenProvider,
  NetworkInfo,
])
import 'api_unit_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late MockDioClient mockDioClient;
  late MockTokenProvider mockTokenProvider;
  late MockNetworkInfo mockNetworkInfo;
  late ApiService apiService;

  setUp(() {
    mockDio = MockDio();
    mockDioClient = MockDioClient();
    mockTokenProvider = MockTokenProvider();
    mockNetworkInfo = MockNetworkInfo();

    // Inject the mock DioClient into the singleton ApiService
    ApiService().setDioClientForTesting(mockDioClient);
  });

  tearDown(() {
    reset(mockDio);
    reset(mockDioClient);
    reset(mockTokenProvider);
    reset(mockNetworkInfo);
  });

  group('Buds API Tests', () {
    // Commented out: no corresponding method in ApiService
    // test('get bud profile', () async {
    //   // Mock response from Postman collection
    //   final mockResponse = Response(
    //     data: {
    //       "message": "Get Bud Profile",
    //       "data": {
    //         "common_artists_data": [
    //           {
    //             "uid": "3a9c62ab05604a25a966a3cc522814a8",
    //             "name": "Fugazi",
    //             "spotify_id": "62sC6lUEWRjbFqXpMmOk4G",
    //             "href": "https://api.spotify.com/v1/artists/62sC6lUEWRjbFqXpMmOk4G",
    //             "popularity": null,
    //             "type": null,
    //             "uri": "spotify:artist:62sC6lUEWRjbFqXpMmOk4G",
    //             "spotify_url": "https://open.spotify.com/artist/62sC6lUEWRjbFqXpMmOk4G",
    //             "followers": 571598,
    //             "images": [
    //               "https://i.scdn.co/image/0234b34b265a6ec22de6b4ebb52abc4d6c9d7371",
    //               "https://i.scdn.co/image/4d6612201d8bbf1a8e5b3ef6ced9d5b0e92d1dd3",
    //               "https://i.scdn.co/image/9f6d3f86533750a49e3dbc215ae9edf54b95a04c"
    //             ],
    //             "genres": [
    //               "alternative rock",
    //               "dc hardcore",
    //               "noise pop",
    //               "noise rock",
    //               "post-hardcore",
    //               "post-punk",
    //               "punk"
    //             ]
    //           }
    //         ],
    //         "common_tracks_data": [
    //           {
    //             "uid": "e8310876443f4608b6faeca61388aad6",
    //             "name": "On The Radio",
    //             "spotify_id": "3C49SjmcPgBiR4KrlK0TBc",
    //             "href": "https://api.spotify.com/v1/tracks/3C49SjmcPgBiR4KrlK0TBc",
    //             "popularity": 33,
    //             "type": null,
    //             "uri": "spotify:track:3C49SjmcPgBiR4KrlK0TBc",
    //             "duration_ms": 199876,
    //             "disc_number": 1,
    //             "explicit": false,
    //             "preview_url": "https://p.scdn.co/mp3-preview/fd2cf82afa2ba950ab8e8bd98addfd19b36f53d4?cid=cd3fb6fd6379457bacc7f3559ba36c13",
    //             "track_number": 7,
    //             "spotify_url": "https://open.spotify.com/track/3C49SjmcPgBiR4KrlK0TBc",
    //             "images": null,
    //             "image_heights": null,
    //             "image_widthes": null
    //           }
    //         ],
    //         "common_genres_data": [
    //           {
    //             "uid": "59e3e8c40e7741d786e6f95d70162546",
    //             "name": "alternative rock"
    //           }
    //         ]
    //       }
    //     },
    //     statusCode: 200,
    //     requestOptions: RequestOptions(path: '/bud/profile'),
    //   );

    //   when(mockDioClient.post('/bud/profile', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'}))
    //       .thenAnswer((_) async => mockResponse);

    //   // Since ApiService is singleton, we test the method directly by mocking
    //   // For this test, we'll assume we can access the method
    //   // In a real scenario, we'd need dependency injection

    //   // Verify the request was made correctly
    //   verify(mockDioClient.post('/bud/profile', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a'})).called(1);
    // });

    test('get buds by top artists', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonArtistsCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/top/artists'),
      );

      when(mockDioClient.post('/bud/top/artists', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      await ApiService().getTopArtistsBuds();

      verify(mockDioClient.post('/bud/top/artists', data: anyNamed('data'))).called(1);
    });

    test('get buds by top tracks', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [
              {
                "bud_uid": "c4f877ddac614d3f900b3e11c1881fc5",
                "common_tracks_count": 2,
                "common_tracks": [
                  {
                    "uid": "e8310876443f4608b6faeca61388aad6",
                    "name": "On The Radio",
                    "spotify_id": "3C49SjmcPgBiR4KrlK0TBc",
                    "href": "https://api.spotify.com/v1/tracks/3C49SjmcPgBiR4KrlK0TBc",
                    "popularity": 33,
                    "type": null,
                    "uri": "spotify:track:3C49SjmcPgBiR4KrlK0TBc",
                    "duration_ms": 199876,
                    "disc_number": 1,
                    "explicit": false,
                    "preview_url": "https://p.scdn.co/mp3-preview/fd2cf82afa2ba950ab8e8bd98addfd19b36f53d4?cid=cd3fb6fd6379457bacc7f3559ba36c13",
                    "track_number": 7,
                    "spotify_url": "https://open.spotify.com/track/3C49SjmcPgBiR4KrlK0TBc"
                  }
                ]
              }
            ],
            "totalCommonTracksCount": 2
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/top/tracks'),
      );

      when(mockDioClient.post('/bud/top/tracks', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      await ApiService().getTopTracksBuds();

      verify(mockDioClient.post('/bud/top/tracks', data: anyNamed('data'))).called(1);
    });

    test('get buds by top genres', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonGenresCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/top/genres'),
      );

      when(mockDioClient.post('/bud/top/genres', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      await ApiService().getTopGenresBuds();

      verify(mockDioClient.post('/bud/top/genres', data: anyNamed('data'))).called(1);
    });

    test('get buds by top anime', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonAnimeCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/top/anime'),
      );

      when(mockDioClient.post('/bud/top/anime', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/top/anime', data: anyNamed('data'))).called(1);
    });

    test('get buds by top manga', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonMangaCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/top/manga'),
      );

      when(mockDioClient.post('/bud/top/manga', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/top/manga', data: anyNamed('data'))).called(1);
    });

    test('get buds by liked artists', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [
              {
                "bud_uid": "c4f877ddac614d3f900b3e11c1881fc5",
                "common_artists_count": 2,
                "common_artists": [
                  {
                    "uid": "1cd09da9f3784f35ba91e228df881e85",
                    "name": "Genuinos Extractos Nihilistas G.E.N",
                    "spotify_id": "6DsKuajPyq0DSlVnt4pvWQ",
                    "href": "https://api.spotify.com/v1/artists/6DsKuajPyq0DSlVnt4pvWQ",
                    "popularity": null,
                    "type": "artist",
                    "uri": "spotify:artist:6DsKuajPyq0DSlVnt4pvWQ",
                    "spotify_url": "https://open.spotify.com/artist/6DsKuajPyq0DSlVnt4pvWQ",
                    "followers": null,
                    "images": null,
                    "image_heights": null,
                    "image_widthes": null,
                    "genres": null
                  }
                ]
              }
            ],
            "totalCommonArtistsCount": 2
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/liked/artists'),
      );

      when(mockDioClient.post('/bud/liked/artists', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/liked/artists', data: anyNamed('data'))).called(1);
    });

    test('get buds by liked tracks', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [
              {
                "uid": "c4f877ddac614d3f900b3e11c1881fc5",
                "email": null,
                "country": null,
                "display_name": "fake_user 1",
                "bio": null,
                "is_active": true,
                "is_authenticated": null,
                "commonTracksCount": 2,
                "commonTracks": [
                  {
                    "uid": "0b8ce6a044334131948a5ea3532a0021",
                    "name": "Alby Ekhtarak",
                    "spotify_id": "7pqmDQxsJBouUVjkZT1u3m",
                    "href": "https://api.spotify.com/v1/tracks/7pqmDQxsJBouUVjkZT1u3m",
                    "popularity": 33,
                    "type": null,
                    "uri": "spotify:track:7pqmDQxsJBouUVjkZT1u3m",
                    "duration_ms": 250998,
                    "disc_number": 1,
                    "explicit": false,
                    "preview_url": "https://p.scdn.co/mp3-preview/f266034077eddf57346eff4d9c6aa7eec2b332ad?cid=cd3fb6fd6379457bacc7f3559ba36c13",
                    "track_number": 9,
                    "spotify_url": "https://open.spotify.com/track/7pqmDQxsJBouUVjkZT1u3m"
                  }
                ]
              }
            ],
            "totalCommonTracksCount": 2
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/liked/tracks'),
      );

      when(mockDioClient.post('/bud/liked/tracks', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/liked/tracks', data: anyNamed('data'))).called(1);
    });

    test('get buds by liked genres', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonGenresCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/liked/genres'),
      );

      when(mockDioClient.post('/bud/liked/genres', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/liked/genres', data: anyNamed('data'))).called(1);
    });

    test('get buds by liked albums', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [
              {
                "bud_uid": "c4f877ddac614d3f900b3e11c1881fc5",
                "common_albums_count": 3,
                "common_albums": [
                  {
                    "uid": "7a3603bc98d6420bbe06c8f54d503074",
                    "spotify_id": "3NFjWkK22DPNhi3hmXsyQb",
                    "name": "Atlas",
                    "href": null,
                    "label": null,
                    "album_type": "album",
                    "release_date": "2014-09-23",
                    "total_tracks": 8,
                    "uri": "spotify:album:3NFjWkK22DPNhi3hmXsyQb",
                    "upc": null,
                    "spotify_url": "https://open.spotify.com/album/3NFjWkK22DPNhi3hmXsyQb",
                    "image_heights": [640, 300, 64],
                    "image_widthes": [640, 300, 64],
                    "artists": [],
                    "tracks": []
                  }
                ]
              }
            ],
            "totalCommonAlbumsCount": 6
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/liked/albums'),
      );

      when(mockDioClient.post('/bud/liked/albums', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/liked/albums', data: anyNamed('data'))).called(1);
    });

    test('get buds by liked aio', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [
              {
                "uid": "c4f877ddac614d3f900b3e11c1881fc5",
                "email": null,
                "country": null,
                "display_name": "fake_user 1",
                "bio": null,
                "is_active": true,
                "is_authenticated": null,
                "commonArtistsCount": 2,
                "commonTracksCount": 2,
                "commonGenresCount": 0,
                "commonAlbumsCount": 3,
                "commonArtists": [],
                "commonTracks": [],
                "commonGenres": [],
                "commonAlbums": [
                  {
                    "uid": "7a3603bc98d6420bbe06c8f54d503074",
                    "spotify_id": "3NFjWkK22DPNhi3hmXsyQb",
                    "name": "Atlas",
                    "href": null,
                    "label": null,
                    "album_type": "album",
                    "release_date": "2014-09-23",
                    "total_tracks": 8,
                    "uri": "spotify:album:3NFjWkK22DPNhi3hmXsyQb",
                    "upc": null,
                    "spotify_url": "https://open.spotify.com/album/3NFjWkK22DPNhi3hmXsyQb",
                    "image_heights": [640, 300, 64],
                    "image_widthes": [640, 300, 64],
                    "artists": [],
                    "tracks": []
                  }
                ]
              }
            ],
            "totalCommonArtistsCount": 2,
            "totalCommonTracksCount": 2,
            "totalCommonGenresCount": 0,
            "totalCommonAlbumsCount": 6
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/liked/aio'),
      );

      when(mockDioClient.post('/bud/liked/aio', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/liked/aio', data: anyNamed('data'))).called(1);
    });

    test('get buds by played tracks', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonTracksCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/played/tracks'),
      );

      when(mockDioClient.post('/bud/played/tracks', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/played/tracks', data: anyNamed('data'))).called(1);
    });

    test('get buds by track', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [
              {
                "uid": "c4f877ddac614d3f900b3e11c1881fc5",
                "email": null,
                "country": null,
                "display_name": "fake_user 1",
                "bio": null,
                "is_active": true,
                "is_authenticated": null,
                "commonTracksCount": 2,
                "commonTracks": [
                  {
                    "uid": "0b8ce6a044334131948a5ea3532a0021",
                    "name": "Alby Ekhtarak",
                    "spotify_id": "7pqmDQxsJBouUVjkZT1u3m",
                    "href": "https://api.spotify.com/v1/tracks/7pqmDQxsJBouUVjkZT1u3m",
                    "popularity": 33,
                    "type": null,
                    "uri": "spotify:track:7pqmDQxsJBouUVjkZT1u3m",
                    "duration_ms": 250998,
                    "disc_number": 1,
                    "explicit": false,
                    "preview_url": "https://p.scdn.co/mp3-preview/f266034077eddf57346eff4d9c6aa7eec2b332ad?cid=cd3fb6fd6379457bacc7f3559ba36c13",
                    "track_number": 9,
                    "spotify_url": "https://open.spotify.com/track/7pqmDQxsJBouUVjkZT1u3m"
                  }
                ]
              }
            ],
            "totalCommonTracksCount": 2
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/track'),
      );

      when(mockDioClient.post('/bud/track', data: {'track_id': '3ca5bebc7e4c4b208f24a771bbcde4d5'}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/track', data: {'track_id': '3ca5bebc7e4c4b208f24a771bbcde4d5'})).called(1);
    });

    test('get buds by artist', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonArtistsCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/artist'),
      );

      when(mockDioClient.post('/bud/artist', data: {'artist_id': 'ffc25621d22e4c4c8ca3617f65d74abb'}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/artist', data: {'artist_id': 'ffc25621d22e4c4c8ca3617f65d74abb'})).called(1);
    });

    test('get buds by genre', () async {
      final mockResponse = Response(
        data: {
          "message": "Fetched buds successfully.",
          "code": 200,
          "successful": true,
          "data": {
            "buds": [],
            "totalCommonGenresCount": 0
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/genre'),
      );

      when(mockDioClient.post('/bud/genre', data: {'genre_id': '0b8ce6a044334131948a5ea3532a0021'}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/genre', data: {'genre_id': '0b8ce6a044334131948a5ea3532a0021'})).called(1);
    });
  });

  group('Auth API Tests', () {
    test('spotify connect', () async {
      final mockResponse = Response(
        data: {
          "message": "Spotify connected successfully",
          "success": true
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/spotify/connect'),
      );

      when(mockDioClient.post('/spotify/connect', data: {'spotify_token': 'fake_spotify_token'}))
          .thenAnswer((_) async => mockResponse);

      await ApiService().handleSpotifyToken('fake_spotify_token');

      verify(mockDioClient.post('/spotify/connect', data: {'spotify_token': 'fake_spotify_token'})).called(1);
    });

    test('ytmusic connect', () async {
      final mockResponse = Response(
        data: {
          "message": "YouTube Music connected successfully",
          "success": true
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/ytmusic/connect'),
      );

      when(mockDioClient.post('/ytmusic/connect', data: {'token': 'fake_token', 'ytmusic_token': 'fake_ytmusic_token'}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/ytmusic/connect', data: {'token': 'fake_token', 'ytmusic_token': 'fake_ytmusic_token'})).called(1);
    });

    test('lastfm connect', () async {
      final mockResponse = Response(
        data: {
          "message": "Last.fm connected successfully",
          "success": true
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/lastfm/connect'),
      );

      when(mockDioClient.post('/lastfm/connect', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/lastfm/connect', data: anyNamed('data'))).called(1);
    });

    test('mal connect', () async {
      final mockResponse = Response(
        data: {
          "message": "MyAnimeList connected successfully",
          "success": true
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/mal/connect'),
      );

      when(mockDioClient.post('/mal/connect', data: {'mal_token': 'fake_mal_token'}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/mal/connect', data: {'mal_token': 'fake_mal_token'})).called(1);
    });

    test('login', () async {
      final mockResponse = Response(
        data: {
          "access_token": "fake_access_token",
          "refresh_token": "fake_refresh_token"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/login'),
      );

      when(mockDioClient.post('/login', data: {'username': 'fake_user', 'password': 'password'}))
          .thenAnswer((_) async => mockResponse);

      await ApiService().login('fake_user', 'password');

      verify(mockDioClient.post('/login', data: {'username': 'fake_user', 'password': 'password'})).called(1);
    });

    test('register', () async {
      final mockResponse = Response(
        data: {
          "status": "success",
          "tokens": {
            "access": "fake_access_token",
            "refresh": "fake_refresh_token"
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/register'),
      );

      when(mockDioClient.post('/register', data: {
        'email': 'mnagy3003@gmail.com',
        'username': 'crazydiamond',
        'password': 'password',
        'confirm_password': 'password'
      })).thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/register', data: {
        'email': 'mnagy3003@gmail.com',
        'username': 'crazydiamond',
        'password': 'password',
        'confirm_password': 'password'
      })).called(1);
    });

    test('service login', () async {
      final mockResponse = Response(
        data: {
          "data": {
            "authorization_link": "https://accounts.spotify.com/authorize?..."
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/service/login'),
      );

      when(mockDioClient.get('/service/login', queryParameters: {'service': 'spotify'}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.get('/service/login', queryParameters: {'service': 'spotify'})).called(1);
    });

    test('spotify refresh-token', () async {
      final mockResponse = Response(
        data: {
          "access_token": "new_fake_access_token"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/spotify/token/refresh'),
      );

      when(mockDioClient.post('/spotify/token/refresh', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/spotify/token/refresh', data: anyNamed('data'))).called(1);
    });
  });

  group('Common API Tests', () {
    test('top artists', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_artist_uid",
              "name": "Test Artist",
              "spotify_id": "test_spotify_id"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/top/artists'),
      );

      when(mockDioClient.post('/bud/common/top/artists', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/top/artists', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });

    test('top tracks', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_track_uid",
              "name": "Test Track",
              "spotify_id": "test_spotify_id"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/top/tracks'),
      );

      when(mockDioClient.post('/bud/common/top/tracks', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/top/tracks', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });

    test('top genres', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_genre_uid",
              "name": "Test Genre"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/top/genres'),
      );

      when(mockDioClient.post('/bud/common/top/genres', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/top/genres', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });

    test('top anime', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_anime_uid",
              "name": "Test Anime"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/top/anime'),
      );

      when(mockDioClient.post('/bud/common/top/anime', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/top/anime', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });

    test('top manga', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_manga_uid",
              "name": "Test Manga"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/top/manga'),
      );

      when(mockDioClient.post('/bud/common/top/manga', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/top/manga', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });

    test('liked artists', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_artist_uid",
              "name": "Test Artist"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/liked/artists'),
      );

      when(mockDioClient.post('/bud/common/liked/artists', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/liked/artists', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });

    test('liked tracks', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_track_uid",
              "name": "Test Track"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/liked/tracks'),
      );

      when(mockDioClient.post('/bud/common/liked/tracks', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/liked/tracks', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });

    test('liked genres', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_genre_uid",
              "name": "Test Genre"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/liked/genres'),
      );

      when(mockDioClient.post('/bud/common/liked/genres', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/liked/genres', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });

    test('liked albums', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_album_uid",
              "name": "Test Album"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/liked/albums'),
      );

      when(mockDioClient.post('/bud/common/liked/albums', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/liked/albums', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });

    test('played tracks', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_track_uid",
              "name": "Test Track"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/bud/common/played/tracks'),
      );

      when(mockDioClient.post('/bud/common/played/tracks', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/bud/common/played/tracks', data: {'bud_id': 'fe534f6caa5b4f0999698b7588fc1f4e', 'page': 1})).called(1);
    });
  });

  group('Me API Tests', () {
    test('get profile', () async {
      final mockResponse = Response(
        data: {
          "id": "test_user_id",
          "username": "test_user",
          "email": "test@example.com"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/profile'),
      );

      when(mockDioClient.post('/me/profile', data: {}))
          .thenAnswer((_) async => mockResponse);

      await ApiService().getUserProfile();

      verify(mockDioClient.post('/me/profile', data: {})).called(1);
    });

    test('set profile', () async {
      final mockResponse = Response(
        data: {
          "message": "Profile updated successfully"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/profile/set'),
      );

      when(mockDioClient.post('/me/profile/set', data: {
        'service': 'spotify',
        'token': 'fake_token',
        'bio': '"cool bio"',
        'display_name': '"mahmoud khashaba"'
      })).thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/profile/set', data: {
        'service': 'spotify',
        'token': 'fake_token',
        'bio': '"cool bio"',
        'display_name': '"mahmoud khashaba"'
      })).called(1);
    });

    test('update my likes', () async {
      final mockResponse = Response(
        data: {
          "message": "Updated Likes successfully"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/likes/update'),
      );

      when(mockDioClient.post('/me/likes/update', data: {'service': 'spotify'}))
          .thenAnswer((_) async => mockResponse);

      await ApiService().updateLikes('spotify');

      verify(mockDioClient.post('/me/likes/update', data: {'service': 'spotify'})).called(1);
    });

    test('top artists', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_artist_uid",
              "name": "Test Artist"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/top/artists'),
      );

      when(mockDioClient.post('/me/top/artists', data: {'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/top/artists', data: {'page': 1})).called(1);
    });

    test('top tracks', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_track_uid",
              "name": "Test Track"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/top/tracks'),
      );

      when(mockDioClient.post('/me/top/tracks', data: {'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/top/tracks', data: {'page': 1})).called(1);
    });

    test('top genres', () async {
      final mockResponse = Response(
        data: {
          "data": ["test_genre"]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/top/genres'),
      );

      when(mockDioClient.post('/me/top/genres', data: {'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/top/genres', data: {'page': 1})).called(1);
    });

    test('top anime', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_anime_uid",
              "name": "Test Anime"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/top/anime'),
      );

      when(mockDioClient.post('/me/top/anime', data: {'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/top/anime', data: {'page': 1})).called(1);
    });

    test('top manga', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_manga_uid",
              "name": "Test Manga"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/top/manga'),
      );

      when(mockDioClient.post('/me/top/manga', data: {'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/top/manga', data: {'page': 1})).called(1);
    });

    test('liked artists', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_artist_uid",
              "name": "Test Artist"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/liked/artists'),
      );

      when(mockDioClient.post('/me/liked/artists', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/liked/artists', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });

    test('liked tracks', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_track_uid",
              "name": "Test Track"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/liked/tracks'),
      );

      when(mockDioClient.post('/me/liked/tracks', data: {'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/liked/tracks', data: {'page': 1})).called(1);
    });

    test('liked genres', () async {
      final mockResponse = Response(
        data: {
          "data": ["test_genre"]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/liked/genres'),
      );

      when(mockDioClient.post('/me/liked/genres', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/liked/genres', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });

    test('liked albums', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_album_uid",
              "name": "Test Album"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/liked/albums'),
      );

      when(mockDioClient.post('/me/liked/albums', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/liked/albums', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });

    test('played tracks', () async {
      final mockResponse = Response(
        data: {
          "data": [
            {
              "uid": "test_track_uid",
              "name": "Test Track"
            }
          ]
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/me/played/tracks'),
      );

      when(mockDioClient.post('/me/played/tracks', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1}))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/me/played/tracks', data: {'bud_id': 'f8ee0077986d4ce282789f35ab35c03a', 'page': 1})).called(1);
    });
  });

  group('Other API Tests', () {
    test('spotify create user seed', () async {
      final mockResponse = Response(
        data: {
          "message": "User seed created successfully"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/spotify/seed/user/create'),
      );

      when(mockDioClient.get('/spotify/seed/user/create'))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.get('/spotify/seed/user/create')).called(1);
    });

    test('merge similars', () async {
      final mockResponse = Response(
        data: {
          "message": "Similars merged successfully"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/merge-similars'),
      );

      when(mockDioClient.get('/merge-similars'))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.get('/merge-similars')).called(1);
    });

    test('health', () async {
      final mockResponse = Response(
        data: {
          "status": "healthy"
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/health'),
      );

      when(mockDioClient.post('/health', data: anyNamed('data')))
          .thenAnswer((_) async => mockResponse);

      verify(mockDioClient.post('/health', data: anyNamed('data'))).called(1);
    });
  });
}