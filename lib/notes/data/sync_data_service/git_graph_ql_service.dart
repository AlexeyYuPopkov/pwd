import 'package:graphql/client.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:pwd/notes/data/graph_ql_schema/git_file_sha.graphql.dart';

final class GitGraphQlService {
  GraphQLClient _getClient({required String token}) {
    final httpLink = HttpLink('https://api.github.com/graphql');

    final authLink = AuthLink(getToken: () => 'Bearer $token');

    final link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }

  Future<String?> getFileSha({
    required String token,
    required GitConfiguration configuration,
  }) async {
    final client = _getClient(token: token);

    final response = await client.query$Repository(
      Options$Query$Repository(
        variables: Variables$Query$Repository(
          name: configuration.repo,
          owner: configuration.owner,
          path: configuration.path,
        ),
      ),
    );

    final data = response.data;

    if (response.hasException || data == null) {
      await client.link.dispose();

      // TODO: Map not found error
      throw GetGitFileShaError(exception: response.exception);
    }

    final parsed = Query$Repository.fromJson(data);

    await client.link.dispose();

    return parsed.repository?.object?.oid;
  }
}

// Errors
sealed class GitGraphQLServiceError {
  const GitGraphQLServiceError();
}

final class UndefinedError extends GitGraphQLServiceError {
  const UndefinedError();
}

final class GetGitFileShaError extends GitGraphQLServiceError {
  final Exception? exception;

  const GetGitFileShaError({required this.exception});
}

extension on GitConfiguration {
  String get path => '$branch:$fileName';
}
