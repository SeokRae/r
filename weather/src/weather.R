# 데이터 호출

# weather = read.csv("weather.csv", stringsAsFactors = F)
# 데이터 확인
weather



length(weather$Date) # 데이터 객체의 요소들의 개수

names(weather) # 데이터 객체 구성요소 이름

class(weather) # 데이터 객체 구성요소의 속성

attributes(weather) # 변수 속성 보기

summary(weather) # 데이터 요약 보기

dim(weather) # 데이터 객체의 차원보기

head(weather) # 상위 6개 관측치 미리보기

tail(weather) # 하위 6개 관측치 미리보기

str(weather) # 데이터 구조, 변수 개수, 변수 명, 관찰치 개수, 관찰치의 미리보기


# 데이터 전처리
weather_num <- weather[, c(-1, -6, -8, -14, -15)]
str(weather_num)
# 결측치 확인
colSums(is.na(weather_num))

# 상관계수 확인
cor(weather_num, method = "pearson") # 상관관계 확인

weather_num2 <- na.omit(weather_num) # 결측치를 포함한 행 제거

colSums(is.na(weather_num2)) # 결측치 제거 확인

cor(weather_num2, method = "pearson")

panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
} 

# 다음으로 산점도 행렬의 위쪽에 상관계수 숫자를 집어넣는 사용자 정의 함수
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
} 

# 산점도에 선형 회귀선을 추가하는 사용자 정의 함수
panel.lm <- function(x, y, col=par("col"), bg=NA, pch=par("pch"), 
                     cex=1, col.smooth="black", ...) {
  points(x, y, pch=pch, col=col, bg=bg, cex=cex) 
  abline(stats::lm(y~x), col=col.smooth, ...)
} 

# 산점도 행렬(scatter-plot matrix), 상관계수(correlation), 히스토그램(histogram)
pairs(
  weather_num2,
  lower.panel = panel.lm,
  upper.panel = panel.cor,
  diag.panel = panel.hist,
  pch="*",
  main = "산점도 행렬, 상관계수 , 히스토그램"
)

pairs(
  weather_num2,
  pch=21,
  bg=rainbow(10)
)

# 관련이 있는 데이터만 다시 전처리
weather_num3 <- weather_num2[, c(-3)]

# cor(weather_num3, method="pearson") # 대상변수가 등간척도 또는 비율척도 일 때 pearson 상관계수를 적용
# cor(weather_num3, method="spearman") # 서열척도일 때는 spearman 상관계수를 적용
pairs(
  weather_num3,
  lower.panel = panel.lm,
  upper.panel = panel.cor,
  diag.panel = panel.hist,
  pch=21,
  bg=rainbow(5)
)

weather_df <- weather[, c(-1, -6, -8, -14)] # chr 데이터 타입 컬럼, Date, RainToday 컬럼 제거
str(weather_df) # 컬럼 삭제 후 확인

weather_df$RainTomorrow[weather_df$RainTomorrow=="Yes"] <- 1 # Yes -> 1
weather_df$RainTomorrow[weather_df$RainTomorrow=="No"] <- 0 # Tes -> 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow) # 수정한 값을 numeric으로 형변환


head(weather_df)


# 단순 임의 추출
idx <- sample(1:nrow(weather_df), nrow(weather_df) * 0.7) # 70%의 데이터만을 training 데이터로  사
train <- weather_df[idx, ]
# train <- na.omit(train)
test <- weather_df[-idx, ]
# colSums(is.na(train))


# 로지스틱 

# generalized linear model
# glm(y ~ x, data, family)
# family의 'binomial'은 y 변수가 이항형인 경우 지정하는 속성 값
weather_model <- glm(RainTomorrow ~ ., data=train, family="binomial")
# weather_model
summary(weather_model)


# - 표의 가장 우측 열의 p-value가 0.05보다 낮은 변수가 통계적으로 유의하다.
# - Sunshine, WindGustSpeed, Humidity, Pressure
# - 가장 낮은 Pressure의 p-value가 가장 낮은 것으로 보아 예측력이 좀 더 강한 것으로 보인다.

# 예측치 생성

# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측 
pred <- predict(weather_model, newdata=test, type="response")
pred # 1에 가까울 수록 비올 확률이 높다.
# summary(pred)
# str(pred)
# 예측치 : 0과 1로 변환(0.5 기준)
result_pred <- ifelse(pred >= 0.5, 1, 0)
result_pred
# table(data.frame)
table(result_pred)

# - 모델을 평가하기 위해서는 혼돈 매트릭스를 이용한다.
# - 예측치가 확률 값으로 제공되기 때문에 이를 이항형으로 변환하는 과정이 필요하다.
# - ifelse() 함수를 이용하여 예측치의 vector변수(pred)를 입력으로 이항형의 vector 변수(result_pred)를 생성

# 분류정확도 계산
table(result_pred, test$RainTomorrow)

## result_pred  0  1
##           0 83 13
##           1  1 12
(83 + 12) / nrow(test)

# Receiver Operating Characteristic
# install.packages("ROCR")
library(ROCR)
# ROCR 패키지 제공 함수 : prediction() -> performance
#
pr <- prediction(pred, test$RainTomorrow)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)


library(rpart)
weather.df <- rpart(RainTomorrow ~., data=weather[, c(-1, -14)], cp=0.01)

plot(weather.df) # 트리 프레임 보임
text(weather.df, use.n = T, cex=0.7) # 텍스트 추가
post(weather.df, file="") # 타원제공 - rpart 패키지 제공 

weather_pred <- predict(weather.df, weather)
head(weather_pred)

weather_pred2 <- ifelse(weather_pred[,2] >= 0.5, 'Yes', 'No' )

table(weather_pred2, weather$RainTomorrow)
(278 + 53) / nrow(weather)
