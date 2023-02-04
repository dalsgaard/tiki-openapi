
## _openapi_

```
openapi 'Demo Spec'
```

```
{
  "openapi": "3.0.3",
  "info": {
    "title": "Demo Spec",
    "version": "1.0.0"
  },
  "paths": {
  }
}
```

```
openapi 'Demo Spec', :spec_version: '3.0.3'
```

## _info_

```
openapi do
  info 'Demo Spec'
end
```

```
openapi do
  info 'Demo Spec', '1.0.0
end
```

```
openapi do
  info title: 'Demo Spec', version: '1.0.0
end
```
