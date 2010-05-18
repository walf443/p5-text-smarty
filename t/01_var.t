use strict;
use warnings;
use utf8;
use Test::Base;
use Test::Differences;
use Text::Smarty::Parser;
use Text::Smarty::Parser::Token::Variable;

run {
    my $block = shift;

    my $parser = Text::Smarty::Parser->new;
    my $expected = $parser->parse($block->input);
    eq_or_diff($expected, $block->expected);
    
};

__END__
===
--- input
あいうえお
{$var}
かきくけこ

--- expected eval
[
    "あいうえお\n",
    Text::Smarty::Parser::Token::Variable->new(name => "var"),
    "\nかきくけこ\n",
]

===
--- input
あいうえお
{if $var}
かきくけこ
{else}
さしすせそ
{/if}
たちつてと

--- expected
[
    "あいうえお\n",
    IF
     | cond
         | <#Var name="var">
     | true
         | [ "かきくけこ\n" ]
     | false
         | [ "さしすせそ\n" ],
    "たちつてと\n"
]
