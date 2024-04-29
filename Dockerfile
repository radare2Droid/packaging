ARG jdk=17.0.10_7
ARG android=34

FROM saschpe/android-sdk:${android}-jdk${jdk}

ARG cmake=3.22.1
ARG ndk=22.1.7171670

ENV ANDROID_HOME="${ANDROID_SDK_ROOT}"
ENV NDK_ROOT "${ANDROID_SDK_ROOT}/ndk/${ndk}"
RUN sdkmanager --install \
    "cmake;${cmake}" \
    "ndk;${ndk}"

RUN apt-get update && apt-get install -y python3.11 python3-pip python3.11-venv patchelf git

RUN git clone https://github.com/chaquo/chaquopy --depth=1

WORKDIR /chaquopy

RUN target/download-target.sh maven/com/chaquo/python/target/3.11.6-0

WORKDIR /chaquopy/server/pypi

RUN pip install -r requirements.txt

COPY scripts/build.sh /chaquopy/server/pypi/build.sh

RUN chmod a+x build.sh

CMD [ "./build.sh" ]
