{ fetchgit }:

{
  version = "21.02.10";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "1b0be8";
    sha256 = "0d8irg20hrj8dw8lq8lcax3nyq4j4bh3sw1izcygifsx6qyzzxf9";
  };
}
