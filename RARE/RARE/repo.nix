{ fetchgit }:

{
  version = "20.10.15";
  src = fetchgit {
    url = "https://bitbucket.software.geant.org/scm/rare/rare.git";
    rev = "b3de54";
    sha256 = "1q8il893qbdqpa4qp3p15aib0jl19qrkbchv9bnqlyx60lpb9b0q";
  };
}
