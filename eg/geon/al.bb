export algorithm

using namespace std
# this should be automatic I think

template<class S, class F> F for_each(S &s, F f)
	return for_each(s.begin(), s.end(), f)

template<class S1, class S2, class F> void mapp(S1 &s1, S2 &s2, F &f)
	s2.clear()
	typename S1::const_iterator i = s1.begin()
	typename S1::const_iterator end = s1.end()
	for ; i!=end ; ++i
		typename S2::value_type i2
		f(*i, i2)
		s2.push_back(i2)
