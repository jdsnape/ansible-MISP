require 'serverspec'

# Required by serverspec
set :backend, :exec

misp_rootdir = '/var/www/_MISP/MISP'

describe file("#{misp_rootdir}/.gnupg/pubring.gpg"), :if => os[:family] != 'ubuntu' || os[:release] != '18.04' do
  it { should be_file }
  it { should exist }
  it { should be_readable.by('owner') }
  it { should_not be_readable.by('others') }
  its(:content) { should_not be_empty }
end

describe file("#{misp_rootdir}/.gnupg/secring.gpg"), :if => os[:family] != 'ubuntu' || os[:release] != '18.04' do
  it { should be_file }
  it { should exist }
  it { should be_readable.by('owner') }
  it { should_not be_readable.by('others') }
#  its(:content) { should_not be_empty }
end

describe file("#{misp_rootdir}/app/webroot/gpg.asc") do
  it { should be_file }
  it { should exist }
  it { should be_readable.by('owner') }
  it { should be_readable.by('group') }
  it { should be_readable.by('others') }
  its(:content) { should_not be_empty }
end

describe command("gpg --homedir #{misp_rootdir}/.gnupg --list-keys") do
  its(:stdout) { should match /MISP Service \(generated by ansible\)/}
  its(:stdout) { should_not match /Error/}
  its(:exit_status) { should eq 0 }
  let(:sudo_options) { '-u www-data -H' }
end
