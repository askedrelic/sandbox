try:
    print 1
    raise ValueError
except ValueError:
    print 'value error'
    raise TypeError
except TypeError:
    print 'tpye error'
    raise Exception
except Exception:
    print 'exception'
