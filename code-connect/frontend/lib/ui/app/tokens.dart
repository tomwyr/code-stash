typedef AppTokens = ({
  double contentMargin,
  double contentPadding,
});

AppTokens get appTokensDefault => (
      contentMargin: 8,
      contentPadding: 12,
    );

AppTokens get appTokensCompact => (
      contentMargin: 0,
      contentPadding: 4,
    );
