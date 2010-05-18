use strict;
use warnings;
use utf8;
use Encode;
use Test::Base;
use Test::Differences;
use Text::Smarty::Parser;
use Text::Smarty::Parser::Token::Variable;
use Text::Smarty::Parser::Token::IF;

plan tests => 1*blocks;

run {
    my $block = shift;

    my $parser = Text::Smarty::Parser->new;
    my $expected = $parser->parse($block->input);
    eq_or_diff($expected, $block->expected, Encode::encode_utf8($block->name));

};

__END__
=== 変数展開
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

=== IF文
--- input
あいうえお
{if $var}
かきくけこ
{else}
さしすせそ
{/if}
たちつてと

--- expected eval
[
    "あいうえお\n",
    Text::Smarty::Parser::Token::IF->new(cond => ['$var']),
    "\nかきくけこ\n",
    Text::Smarty::Parser::Token::ELSE->new(),
    "\nさしすせそ\n",
    Text::Smarty::Parser::Token::ENDIF->new(),
    "\nたちつてと\n"
]

=== Comment
--- input
てすてす
{* これはコメントです *}
てすてす

--- expected eval
[
    "てすてす\n",
    Text::Smarty::Parser::Token::Comment->new(comment => "これはコメントです"),
    "\nてすてす\n",
]

