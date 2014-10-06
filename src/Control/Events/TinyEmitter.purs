module Control.Events.TinyEmitter where

  import Control.Events (Event(), EventEff(), EventEmitter, Variadic)
  import Control.Monad.Eff (Eff())

  import Data.Function (Fn4(), runFn4, Fn3(), runFn3)

  foreign import data TinyEmitter :: *

  instance eventEmitterTinyEmitter :: EventEmitter TinyEmitter

  -- This should probably be part of the type class.
  foreign import emitter """
    function emitter() {
      return new TinyEmitter();
    }
  """ :: forall eff. Eff (event :: EventEff | eff) TinyEmitter

  -- TODO: Move these ffi's into `Control.Events`.
  -- They're the same as node-event.

  foreign import emitterHelper1 """
    function emitterHelper1(__emitter) {
      return function(__variadic) {
        return function(method, event, emitter) {
          return function() {
            return emitter[method](event);
          }
        }
      }
    }
  """ :: forall eff e fn
      .  (EventEmitter e)
      => Fn3 String Event e (Eff (event :: EventEff | eff) e)

  foreign import emitterHelper2 """
    function emitterHelper2(__emitter) {
      return function(__variadic) {
        return function(method, event, cb, emitter) {
          return function() {
            return emitter[method](event, function() {
              return cb.apply(this, arguments)();
            }.bind(this));
          }
        }
      }
    }
  """ :: forall eff e fn
      .  (EventEmitter e, Variadic fn (Eff eff Unit))
      => Fn4 String Event fn e (Eff (event :: EventEff | eff) e)

  foreign import _emit """
    function _emit(__dict) {
      return function(event, arg, emitter) {
        return function() {
          return emitter.emit(event, arg);
        }
      }
    }
  """ :: forall eff e arg. (EventEmitter e)
      => Fn3 Event arg e (Eff (event :: EventEff | eff) e)

  emit :: forall eff e arg. (EventEmitter e)
       => Event -> arg -> e -> Eff (event :: EventEff | eff) e
  emit ev arg e = runFn3 _emit ev arg e

  off :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit))
      => Event -> e -> Eff (event :: EventEff | eff) e
  off ev e = runFn3 emitterHelper1 "off" ev e

  on :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit))
     => Event -> fn -> e -> Eff (event :: EventEff | eff) e
  on ev cb e = runFn4 emitterHelper2 "on" ev cb e

  once :: forall eff e fn. (EventEmitter e, Variadic fn (Eff eff Unit))
       => Event -> fn -> e -> Eff (event :: EventEff | eff) e
  once ev cb e = runFn4 emitterHelper2 "once" ev cb e
