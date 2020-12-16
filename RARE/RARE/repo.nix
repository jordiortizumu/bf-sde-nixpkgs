{ fetchgit }:

{
  version = "20.12.16";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "294753";
    sha256 = "0qba04qzny3cig9rjsajp735wm0gdp7nn4gaij6hpiqlyxa47hjl";
  };
}
