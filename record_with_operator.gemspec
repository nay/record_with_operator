# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{record_with_operator}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yasuko Ohba"]
  s.date = %q{2009-02-20}
  s.description = %q{Rails plugin to set created_by, updated_by, deleted_by to ActiveRecord objects. Supports associations.}
  s.email = %q{y.ohba@everyleaf.com}
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE"]
  s.files = ["README.rdoc", "Rakefile", "MIT-LICENSE", "install.rb", "uninstall.rb", "init.rb", "lib/association_with_operator.rb", "lib/record_with_operator.rb", "tasks/record_with_operator_tasks.rake", "test/database.yml", "test/record_with_operator_belongs_to_association_test.rb", "test/record_with_operator_has_one_association_test.rb", "test/record_with_operator_test.rb", "test/record_with_operator_user_class_name_test.rb", "test/schema.rb", "test/test_helper.rb", "rails/init.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nay/record_with_operator/tree}
  s.rdoc_options = ["--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Rails plugin to set created_by, updated_by, deleted_by to ActiveRecord objects. Supports associations.}
  s.test_files = ["test/database.yml", "test/record_with_operator_belongs_to_association_test.rb", "test/record_with_operator_has_one_association_test.rb", "test/record_with_operator_test.rb", "test/record_with_operator_user_class_name_test.rb", "test/schema.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.2.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.2.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.2.0"])
  end
end
