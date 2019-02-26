
pro cmb_sort_timeseries,t,a
is =sort(t)
t = t[is]
a = a[*,is]
end