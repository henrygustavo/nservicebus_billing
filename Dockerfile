FROM microsoft/dotnet AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet AS build
WORKDIR /src
COPY ["Billing.EndPoint/Billing.EndPoint.csproj", "Billing.EndPoint/"]
COPY ["Billing.Contracts/Billing.Contracts.csproj", "Billing.Contracts/"]
COPY ["Sales.Contracts/Sales.Contracts.csproj", "Sales.Contracts/"]
RUN dotnet restore "Billing.EndPoint/Billing.EndPoint.csproj"
COPY . .
WORKDIR "/src/Billing.EndPoint"
RUN dotnet build "Billing.EndPoint.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Billing.EndPoint.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Billing.EndPoint.dll"]