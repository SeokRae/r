# R 프로그램을 이용한 날씨 데이터 분석

- 데이터를 분석하는 과정

```
1. Data 전처리(NA, NaN 처리)
2. 기술통계분석(빈도수, 요약)
3. 분석모형선정(X -> Y)
4. Data 분석(추론통계, 패턴, 규칙)
5. 분석모형평가(가설검정, 검증 데이터 평가)
```



### 1. 데이터 호출

- 날씨 관련 변수에 따라서 비가 내릴지의 여부를 기록한 데이터
- 이 데이터를 분석하여 어떤 날씨 조건에 비가 내릴지 또는 내리지 않을지에 대한 판단 기준을 분석할 수 있다.
- 데이터 속성

```
Date(측정날짜), MinTemp(최저기온), MaxTemp(최고기온), Rainfall(강수량), Sunshine(햇빛)
WindGustDir(돌풍방향), WidGustSpeed(돌풍 속도), WindDir(바람 방향), WindSpeed(바람 속도)
Humidity(습도), Pressure(기압), Cloud(구름), Temp(온도), RainToday(금일 비 여부)
RainTomorrow(내일 비 여부)
```



### 2. 추론통계

- 수집된 자료를 정리 및 요약하는 기술 통계학 영역
- 모집단에서 추출한 표본의 정보를 이용하여 모집단의 특성을 추론하는 추론 통계학 영역



#### 2 - 1 상관관계 분석

- 변수 간의 관련성을 분석하기 위해 사용하는 분석방법
- 날씨 데이터를 피어슨 상관계수, 히스토그램, 산점도행렬을 통해 분석

![img](https://t1.daumcdn.net/cfile/tistory/9948B4395B1DB0BD15)

### 3. 예측 분석

- 추론 통계 및 패턴(규칙)을 적용하여 미래의 데이터를 예측하는 분석방법



#### 3 - 1 로지스틱 회귀분석

- 독립 변수의 선형 결합을 이용하여 사건의 발생 가능성을 예측하는데 사용되는 통계 기법

![img](https://t1.daumcdn.net/cfile/tistory/999DB1335B1DB0BD18) 

#### 3 - 2 분류분석

- 다수의 변수를 갖는 데이터 셋을 대상으로 특정 변수의 값을 조건으로 지정하여 데이터를 분류하고 트리 형태의 모델을 생성하는 분석방법

![img](https://t1.daumcdn.net/cfile/tistory/994656425B1DB0BD12) 

![img](https://t1.daumcdn.net/cfile/tistory/99BDDA3A5B1DB0BD14)

<a href="weather/doc/weather.html" >정리</a>