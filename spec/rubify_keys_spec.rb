require_relative '../lib/core_extensions/rubify_keys' 

RSpec.describe CoreExtensions::RubifyKeys, '#rubify_keys!' do

  it 'adds #rubify_keys! instance method to hash class' do
    Hash.include CoreExtensions::RubifyKeys
    expect(Hash.method_defined?(:rubify_keys!)).to be true
  end

  it 'changes all camelcase keys to snakecase' do
    Hash.include CoreExtensions::RubifyKeys
    hash = {"camelCase" => "camelCase", 
            "hyphenated-case" => "hyphenated-case",
            "hashKey" => {"nestedCase" => "nestedCase"},
            "arrKey" => [{"arrayCase" => "arrayCase"}, 
                         {"array-Case" => "array-Case"}]
    }
    # TODO style?
    hash.rubify_keys!
    expect(hash).to eq Hash["camel_case" => "camelCase", 
                            "hyphenated_case" => "hyphenated-case",
                            "hash_key" => {"nested_case" => "nestedCase"},
                            "arr_key" => [{"array_case" => "arrayCase"}, 
                                          {"array_case" => "array-Case"}]
    ]
    # TODO sperate test for nesting?
  end
end
