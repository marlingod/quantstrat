\name{ruleSignal}
\alias{ruleSignal}
\title{default rule to generate a trade order on a signal}
\usage{
ruleSignal(mktdata = mktdata, timestamp, sigcol, sigval, orderqty = 0,
  ordertype, orderside = NULL, orderset = NULL, threshold = NULL,
  tmult = FALSE, replace = TRUE, delay = 0.0001, osFUN = "osNoOp",
  pricemethod = c("market", "opside", "active"), portfolio, symbol, ...,
  ruletype, TxnFees = 0, prefer = NULL, sethold = FALSE, label = "",
  order.price = NULL, chain.price = NULL, time.in.force = "")
}
\arguments{
  \item{mktdata}{an xts object containing market data.
  depending on rules, may need to be in OHLCV or BBO
  formats, and may include indicator and signal
  information}

  \item{timestamp}{timestamp coercible to POSIXct that will
  be the time the order will be inserted on}

  \item{sigcol}{column name to check for signal}

  \item{sigval}{signal value to match against}

  \item{orderqty}{numeric quantity of the desired order, or
  one of 'all'/'trigger', modified by osFUN}

  \item{ordertype}{one of "market","limit","stoplimit",
  "stoptrailing", or "iceberg"}

  \item{orderside}{one of either "long" or "short", default
  NULL, see details}

  \item{orderset}{tag to identify an orderset; if one order
  of the set is filled, all others are canceled}

  \item{threshold}{numeric or name of indicator column in
  mktdata, default NULL, see Details}

  \item{tmult}{if TRUE, threshold is a percent multiplier
  for \code{price}, not a scalar. Threshold is converted to
  a scalar by multiplying it with the price at the time of
  order entry (i.e. the scalar will not change if the order
  is updated, as in the case of a trailing stop), then it
  is added to the price just like a scalar threshold.}

  \item{replace}{TRUE/FALSE, whether to replace any other
  open order(s) on this portfolio symbol, default TRUE}

  \item{delay}{what delay to add to timestamp when
  inserting the order into the order book, in seconds}

  \item{osFUN}{function or text descriptor of function to
  use for order sizing, default \code{\link{osNoOp}}}

  \item{pricemethod}{determines how the order price will be
  calculated, see Details}

  \item{portfolio}{text name of the portfolio to place
  orders in}

  \item{symbol}{identifier of the instrument to place
  orders for.  The name of any associated price objects
  (xts prices, usually OHLC) should match these}

  \item{...}{any other passthru parameters}

  \item{ruletype}{one of
  "risk","order","rebalance","exit","entry", see
  \code{\link{add.rule}}}

  \item{TxnFees}{numeric fees (usually negative) or
  function name for calculating TxnFees (processing happens
  later, not in this function)}

  \item{prefer}{price method for getPrice}

  \item{sethold}{boolean, puts entry Rule processing on
  hold, default FALSE}

  \item{label}{rule label, default '', added by
  \code{\link{applyRules}}}

  \item{order.price}{the order price to use, will overrule
  any mktdata lookup as well as chain.price (see below),
  meant to specify eg. a stop-loss price that is unrelated
  to the fill price (see chain.price)}

  \item{chain.price}{the price that the parent order got
  filled for, used to pass to children in the order chain,
  will overrule all mktdata lookup, only meant for internal
  use really, default NULL}

  \item{time.in.force}{timestamp time-in-force; either a
  time stamp, or a number of seconds, or 'GTC' / '', 'GTC'
  and '' both meaning 'Good Till Canceled'; order expires
  if still 'open' at this timestamp, default is ''}
}
\description{
As described elsewhere in the documentation, quantstrat
models \emph{orders}.  This function is the default
provided rule function to generate those orders, which will
be acted on later as they interact with your market data.
}
\details{
\code{pricemethod} may be one of \describe{ \item{'market',
'opside', or 'active'}{ will use the 'ask' price if you're
buying and the 'bid' price if you're selling, crossing the
market at the time of order entry to attempt to set an
aggressive price to get the trade. } \item{'passive',
'work' or 'join'}{ which will join the 'bid' price if you
are buying or join the 'ask' price if you are selling,
passively working to make liquidity at the prevailing
market price without crossing the market at time of order
entry} \item{'maker'}{will create a pair of orders for both
bid and offer, modeling market making activities by having
orders on both sides.  This will then create an Order.Set,
and use the \code{threshold} to set the prices for these
orders.} }

\code{orderqty} should be either numeric, or one of
'all'/'trigger'. 'all' can only be used with order of
ruletype='exit' or 'risk', and will close the entire
position. 'trigger' can only be used with ruletype='chain'
and is exactly identical to 'all', except that the actual
transaction is suppressed, and can be used to kick in a new
order chain.

If \code{threshold} is not numeric or \code{NULL} it should
be the name of an indicator mktdata column holding the
threshold values.

If \code{orderside} is NULL, the function will attempt to
calculate the side from the current position (if any), the
order quantity, and the order type.
}
\seealso{
\code{\link{osNoOp}} , \code{\link{add.rule}}
}

